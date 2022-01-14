//
//  ItemDescriptionInteractor.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation

protocol ItemDescriptionInteractor: AnyObject {
    func viewDidLoad()
    func viewWillAppear(vc: ItemDescriptionViewController)
//    func didSelectRow(at index: Int)
    
}
class ItemDescriptionInteractorImplementation: ItemDescriptionInteractor {
    var presenter: ItemDescriptionPresenter?
    var item: Item?
    
    private let localService = ItemDescriptionLocalServiceImplementation()
    private let remoteService = ItemDescriptionRemoteServiceImplementation()
    
    private var itemDescription: [Item] = []
    
    func viewDidLoad() {
        loadItemDescription()
    }
    
    func viewWillAppear(vc: ItemDescriptionViewController) {
        vc.title = item?.name != nil ? item!.name! + " description" : "None"
    }
    
//    func didSelectRow(at index: Int) {
//        if itemDescription.indices.contains(index) {
//            presenter?.interactor(didFindItemDescription: itemDescription[index])
//        }
//    }
}

// MARK: ItemDescription loader with caching and stuff
extension ItemDescriptionInteractorImplementation {
    private func loadItemDescription() {
        guard let item = item, let id = item.path?.secondComponent else { return }
        localService.getItemDescription(of: id, onSuccess: { localItemDescription in
            if localItemDescription.isEmpty {
                // print("local success empty")
                self.loadRemoteDataAndPresentIt()
            } else {
                // print("local success not empty")
                self.cacheAndNotifyPresenter(localItemDescription)
//                self.loadRemoteDataAndPresentIt()
            }
        }, onFailure: { message in
            print("local error")
            print(message)
            self.loadRemoteDataAndPresentIt()
        })
    }
    
    private func loadRemoteDataAndPresentIt() {
        guard let item = item, let id = item.path?.secondComponent else { return }
        remoteService.getItemDescription(of: id) { remoteItemDescription in
            // print("remote success")
            self.cacheAndNotifyPresenter(remoteItemDescription)
            self.saveToCoreData(remoteItemDescription)
        } onFailure: { message in
            print("remote error")
            print(message)
            self.presenter?.interactor(didFailRetrieveItemDescription: message)
        }
    }

    private func cacheAndNotifyPresenter(_ data: [Item]) {
        // print("cache and present")
        let sortedData = data.sorted {
            if let n1 = $0.name, let n2 = $1.name, n1 != n2 { return n1 < n2 }
            if let i1 = $0.id, let i2 = $1.id { return i1 < i2 }
            return false
        }
        itemDescription = sortedData
        presenter?.interactor(didRetrieveItemDescription: itemDescription)
    }

    private func saveToCoreData(_ itemTypes: [Item]) {
        // print("save in core data")
        CoreDataStore.save()
    }
}
