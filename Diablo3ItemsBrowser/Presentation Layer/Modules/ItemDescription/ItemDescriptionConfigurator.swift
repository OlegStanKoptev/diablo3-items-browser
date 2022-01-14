//
//  ItemDescriptionConfigurator.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import UIKit

class ItemDescriptionConfigurator {
    static func configureModule(viewController: ItemDescriptionViewController, for item: Item) {
        let view = ItemDescriptionView()
        let router = ItemDescriptionRouterImplementation()
        let interactor = ItemDescriptionInteractorImplementation()
        interactor.item = item
        let presenter = ItemDescriptionPresenterImplementation()
        
        viewController.itemDescriptionView = view
        viewController.router = router
        viewController.interactor = interactor
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.navigationController = viewController.navigationController
    }
}
