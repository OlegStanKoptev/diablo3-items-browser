//
//  ItemTypesPresenter.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation

protocol ItemTypesPresenter {
    func interactor(didRetrieveItemTypes itemTypes: [(ItemType, Int?)])
    func interactor(didFailRetrieveItemTypes error: String)
    
    func interactor(didRetrieveItemType itemType: (ItemType, Int?), at index: Int)
    
    func interactor(didFindItemType itemType: ItemType)
}
class ItemTypesPresenterImplementation: ItemTypesPresenter {
    weak var viewController: ItemTypesPresenterOutput?
    
    func interactor(didRetrieveItemTypes itemTypes: [(ItemType, Int?)]) {
        let itemTypesStrings = itemTypes.compactMap(formattedDescription)
        viewController?.presenter(didRetrieveItems: itemTypesStrings)
    }
    
    func interactor(didRetrieveItemType itemType: (ItemType, Int?), at index: Int) {
        guard let itemTypeString = formattedDescription(for: itemType) else { return }
        viewController?.presenter(didRetrieveItem: itemTypeString, for: index)
    }
    
    private func formattedDescription(for pair: (ItemType, Int?)) -> String? {
        guard
            let name = pair.0.name,
            let id = pair.0.id
        else { print("formattedDescription returns nil for \(String(describing: pair))"); return nil }
        guard let count = pair.1 else { return "\(name) (\(id))" }
        return "\(name) (\(id)) - \(count) item\(count == 1 ? "" : "s")"
//        return "\([name, id].joined(separator: ": ")) (\(count) item\(count == 1 ? "" : "s"))"
    }
    
    func interactor(didFailRetrieveItemTypes error: String) {
        viewController?.presenter(didFailRetrieveItems: error)
    }
    
    func interactor(didFindItemType itemType: ItemType) {
        viewController?.presenter(didObtainItemType: itemType)
    }
}
