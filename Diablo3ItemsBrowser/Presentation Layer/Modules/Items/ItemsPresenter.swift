//
//  ItemsPresenter.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation

protocol ItemsPresenter {
    func interactor(didRetrieveItems items: [Item])
    func interactor(didFailRetrieveItems error: String)
    
    func interactor(didFindItem item: Item)
}
class ItemsPresenterImplementation: ItemsPresenter {
    weak var viewController: ItemsPresenterOutput?
    
    func interactor(didRetrieveItems items: [Item]) {
        let itemsStrings = items.compactMap(formattedDescription)
        viewController?.presenter(didRetrieveItems: itemsStrings)
    }
    
    private func formattedDescription(for item: Item) -> String? {
        guard let name = item.name else { print("formattedDescription returns nil for \(String(describing: item))"); return nil }
        guard let id = item.id else { return name }
        return "\(name) (\(id))"
    }
    
    func interactor(didFailRetrieveItems error: String) {
        viewController?.presenter(didFailRetrieveItems: error)
    }
    
    func interactor(didFindItem item: Item) {
        viewController?.presenter(didObtainItem: item)
    }
}
