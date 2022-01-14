//
//  ItemsConfigurator.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import UIKit

class ItemsConfigurator {
    static func configureModule(viewController: ItemsViewController, for itemType: ItemType) {
        let view = ItemsView()
        let router = ItemsRouterImplementation()
        let interactor = ItemsInteractorImplementation()
        interactor.itemType = itemType
        let presenter = ItemsPresenterImplementation()
        
        viewController.itemsView = view
        viewController.router = router
        viewController.interactor = interactor
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.navigationController = viewController.navigationController
    }
}
