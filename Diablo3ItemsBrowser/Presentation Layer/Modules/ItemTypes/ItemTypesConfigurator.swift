//
//  ItemTypesConfigurator.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import UIKit

class ItemTypesConfigurator {
    static func configureModule(viewController: ItemTypesViewController) {
        let view = ItemTypesView()
        let router = ItemTypesRouterImplementation()
        let interactor = ItemTypesInteractorImplementation()
        let presenter = ItemTypesPresenterImplementation()
        
        viewController.typesView = view
        viewController.router = router
        viewController.interactor = interactor
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.navigationController = viewController.navigationController
    }
}
