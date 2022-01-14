//
//  ItemDescriptionPresenter.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation

protocol ItemDescriptionPresenter {
    func interactor(didRetrieveItemDescription ItemDescription: [Item])
    func interactor(didFailRetrieveItemDescription error: String)
    
//    func interactor(didFindItemType item: Item)
}
class ItemDescriptionPresenterImplementation: ItemDescriptionPresenter {
    weak var viewController: ItemDescriptionPresenterOutput?
    
    func interactor(didRetrieveItemDescription ItemDescription: [Item]) {
        let ItemDescriptionStrings = ItemDescription.compactMap(formattedDescription)
        viewController?.presenter(didRetrieveItemDescription: ItemDescriptionStrings)
    }
    
    private func formattedDescription(for item: Item) -> String? {
        guard let name = item.name else { print("formattedDescription returns nil for \(String(describing: item))"); return nil }
        guard let id = item.id else { return name }
        return "\(name) (\(id))"
    }
    
    func interactor(didFailRetrieveItemDescription error: String) {
        viewController?.presenter(didFailRetrieveItemDescription: error)
    }
    
//    func interactor(didFindItemType item: Item) {
//        if let id = item.id {
//            viewController?.presenter(didObtainItemId: id)
//        }
//    }
}
