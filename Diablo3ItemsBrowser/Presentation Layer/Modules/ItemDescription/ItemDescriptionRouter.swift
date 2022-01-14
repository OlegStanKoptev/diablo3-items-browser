//
//  ItemDescriptionRouter.swift
//  Diablo3ItemsBrowserCoreDataTest
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation
import UIKit

protocol ItemDescriptionRouter {
    var navigationController: UINavigationController? { get }
    
    func routeToDetail(with id: String)
}
class ItemDescriptionRouterImplementation: ItemDescriptionRouter {
    weak var navigationController: UINavigationController?
    
    func routeToDetail(with id: String) {
//        let viewController = ItemDescriptionViewController()
//        ItemDescriptionViewConfigurator.configureModule(viewController: viewController)
//
//        navigationController?.pushViewController(viewController, animated: true)
    }
}
