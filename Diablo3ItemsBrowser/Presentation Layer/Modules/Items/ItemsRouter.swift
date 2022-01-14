//
//  ItemsRouter.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation
import UIKit

protocol ItemsRouter {
    var navigationController: UINavigationController? { get }
    
    func routeToDetail(with item: Item)
}
class ItemsRouterImplementation: ItemsRouter {
    weak var navigationController: UINavigationController?
    
    func routeToDetail(with item: Item) {
        let viewController = ItemDescriptionViewController()
        ItemDescriptionConfigurator.configureModule(viewController: viewController, for: item)

        navigationController?.pushViewController(viewController, animated: true)
    }
}
