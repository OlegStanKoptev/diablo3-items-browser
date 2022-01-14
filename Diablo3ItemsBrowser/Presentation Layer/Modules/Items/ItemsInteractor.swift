//
//  ItemsInteractor.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation

protocol ItemsInteractor: AnyObject {
    func viewDidLoad()
    func viewWillAppear(vc: ItemsViewController)
    func didSelectRow(at index: Int)
    
}
class ItemsInteractorImplementation: ItemsInteractor {    
    var presenter: ItemsPresenter?
    var itemType: ItemType?
    
    private let localService = ItemsLocalServiceImplementation()
    private let remoteService = ItemsRemoteServiceImplementation()
    
    private var items: [Item] = []
    
    func viewDidLoad() {
        loadItems()
    }
    
    func viewWillAppear(vc: ItemsViewController) {
        vc.title = itemType?.name ?? "None"
    }
    
    func didSelectRow(at index: Int) {
        if items.indices.contains(index) {
            presenter?.interactor(didFindItem: items[index])
        }
    }
}

// MARK: Items loader with caching and stuff
extension ItemsInteractorImplementation {
    private func loadItems() {
        guard let itemType = itemType, let id = itemType.path?.secondComponent else { return }
        localService.getItems(of: id, onSuccess: { localItems in
            if localItems.isEmpty {
                // print("local success empty")
                self.loadRemoteDataAndPresentIt()
            } else {
                // print("local success not empty")
                self.cacheAndNotifyPresenter(dataCD: localItems)
//                self.loadRemoteDataAndPresentIt()
            }
        }, onFailure: { message in
            print("local error")
            print(message)
            self.loadRemoteDataAndPresentIt()
        })
    }
    
    private func loadRemoteDataAndPresentIt() {
        guard let itemType = itemType, let id = itemType.path?.secondComponent else { return }
        remoteService.getItems(of: id) { remoteItems in
            // print("remote success")
            self.cacheAndNotifyPresenter(dataAPI: remoteItems)
//            self.saveToCoreData(remoteItems)
        } onFailure: { message in
            print("remote error")
            print(message)
            self.presenter?.interactor(didFailRetrieveItems: message)
        }
    }

    private func cacheAndNotifyPresenter(dataCD: [Item]? = nil, dataAPI: [ItemAPI]? = nil) {
        if let data = dataCD {
            let sortedData = data.sorted {
                if let n1 = $0.name, let n2 = $1.name, n1 != n2 { return n1 < n2 }
                if let i1 = $0.id, let i2 = $1.id { return i1 < i2 }
                return false
            }
            self.items = sortedData
            presenter?.interactor(didRetrieveItems: items)
        } else if let data = dataAPI {
            let sortedData = data.sorted {
                if $0.name != $1.name { return $0.name < $1.name }
                return $0.id < $1.id
            }
            
            saveToCoreData(sortedData)
            presenter?.interactor(didRetrieveItems: items)
        }
    }

    private func saveToCoreData(_ items: [ItemAPI]) {
        // print("save in core data")
        guard let itemType = itemType,
              let type = itemType.path?.secondComponent
        else { preconditionFailure() }
        self.items = ItemConverter.convert(toStorable: items, with: type)
        CoreDataStore.save()
    }
}
