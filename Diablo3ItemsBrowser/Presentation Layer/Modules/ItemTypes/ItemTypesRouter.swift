//
//  ItemTypesRouter.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation
import UIKit

protocol ItemTypesRouter {
    var navigationController: UINavigationController? { get }
    
    func routeToDetail(with itemType: ItemType)
}
class ItemTypesRouterImplementation: ItemTypesRouter {
    weak var navigationController: UINavigationController?
    
    func routeToDetail(with itemType: ItemType) {
        let viewController = ItemsViewController()
        ItemsConfigurator.configureModule(viewController: viewController, for: itemType)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
