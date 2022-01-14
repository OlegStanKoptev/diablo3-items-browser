//
//  ItemTypesInteractor.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation

protocol ItemTypesInteractor: AnyObject {
    func viewDidLoad()
    func didSelectRow(at index: Int)
    func cellForRowCallback(at index: Int)
    
}
class ItemTypesInteractorImplementation: ItemTypesInteractor {
    
    var presenter: ItemTypesPresenter?
    
    private let localService = ItemTypesLocalServiceImplementation()
    private let remoteService = ItemTypesRemoteServiceImplementation()
    
    private let itemsLocalService = ItemsLocalServiceImplementation()
    private let itemsRemoteService = ItemsRemoteServiceImplementation()
    
    private var itemTypes: [(ItemType, Int?)] = []
    private var itemTypesLoading: Set<Int> = []
    
    func viewDidLoad() {
        loadItemTypes()
    }
    
    func didSelectRow(at index: Int) {
        if self.itemTypes.indices.contains(index) {
            presenter?.interactor(didFindItemType: self.itemTypes[index].0)
        }
    }
    
    func cellForRowCallback(at index: Int) {
        // queue the load of new information
        askedToLoadItems(at: index)
    }
    
}

// MARK: Item Types loader with caching and stuff
extension ItemTypesInteractorImplementation {
    private func loadItemTypes() {
        localService.getItemTypes(onSuccess: { localItemTypes in
            if localItemTypes.isEmpty {
                // print("local success empty")
                self.loadRemoteDataAndPresentIt()
            } else {
                // print("local success not empty")
                self.cacheAndNotifyPresenter(dataCD: localItemTypes)
//                self.loadRemoteDataAndPresentIt()
            }
        }, onFailure: { message in
            print("local error")
            print(message)
            self.loadRemoteDataAndPresentIt()
        })
    }
    
    private func loadRemoteDataAndPresentIt() {
        remoteService.getItemTypes { remoteItemTypes in
            // print("remote success")
            self.cacheAndNotifyPresenter(dataAPI: remoteItemTypes)
        } onFailure: { message in
            print("remote error")
            print(message)
            self.presenter?.interactor(didFailRetrieveItemTypes: message)
        }
    }
    
    private func cacheAndNotifyPresenter(dataCD: [ItemType]? = nil, dataAPI: [ItemTypeAPI]? = nil) {
        // print("cache and present")
        if let data = dataCD  {
            let sortedData = data.sorted {
                if let n1 = $0.name, let n2 = $1.name, n1 != n2 { return n1 < n2 }
                if let i1 = $0.id, let i2 = $1.id { return i1 < i2 }
                return false
            }
            self.itemTypes = sortedData.map { ($0, nil) }
            presenter?.interactor(didRetrieveItemTypes: itemTypes)
        } else if let data = dataAPI {
            let sortedData = data.sorted {
                if $0.name != $1.name { return $0.name < $1.name }
                return $0.id < $1.id
            }
            
            saveToCoreData(sortedData)
            presenter?.interactor(didRetrieveItemTypes: itemTypes)
        }
    }
    
    private func saveToCoreData(_ itemTypes: [ItemTypeAPI]) {
        // print("save in core data")
        let itemTypesCD = ItemTypeConverter.convert(toStorable: itemTypes)
        self.itemTypes = itemTypesCD.map { ($0, nil) }
        CoreDataStore.save()
    }
}

// MARK: Items loader with caching and stuff
extension ItemTypesInteractorImplementation {
    private func askedToLoadItems(at index: Int) {
        // check if cell info is already loaded
        //  - yes: update ui
        //  - no: check if cell info is loading
        //    - yes: return
        //    - no: queue the load and on finish
        //        save info and update ui
//        return
        guard itemTypes.indices.contains(index), itemTypes[index].1 == nil else { return }
        guard
            let path = itemTypes[index].0.path,
            let itemType = path.secondComponent
        else { preconditionFailure() }
        
        itemsLocalService.getItemsQnt(of: itemType) { count in
            if count != 0 {
                // Local data exists, present
                self.itemTypes[index].1 = count
                self.presenter?.interactor(didRetrieveItemType: self.itemTypes[index], at: index)
            } else {
                // Locally no items, load from the server
                // If already loading, just return
                guard !self.itemTypesLoading.contains(index) else { return }
                // Else request data from the server
                self.itemTypesLoading.insert(index)
                self.itemsRemoteService.getItems(of: itemType) { items in
                    self.itemTypesLoading.remove(index)
                    self.itemTypes[index].1 = items.count
                    
                    self.saveToCoreData(items, for: itemType)
//                    CoreDataStore.save(message: "itemType: \(itemType), items.count: \(items.count)")
                    
                    self.presenter?.interactor(didRetrieveItemType: self.itemTypes[index], at: index)
                } onFailure: { error in
                    fatalError(error)
                }

            }
        } onFailure: { error in
            print(error)
        }
    }
    
    private func saveToCoreData(_ items: [ItemAPI], for itemType: String) {
        // print("save in core data")
        let _ = ItemConverter.convert(toStorable: items, with: itemType)
        CoreDataStore.save()
    }
}
