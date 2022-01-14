//
//  ItemsViewController.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import UIKit

protocol ItemsPresenterOutput: AnyObject {
    func presenter(didRetrieveItems items: [String])
    func presenter(didFailRetrieveItems message: String)
    
    func presenter(didObtainItem item: Item)
    func presenter(didFailObtainItemId message: String)
}

class ItemsViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
        self.view = itemsView
        
        itemsView?.tableView.delegate = self
        itemsView?.tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor?.viewWillAppear(vc: self)
    }
    
    // MARK: - Actions
    func showError(with message: String) {
        NSLog(message)
    }
    
    // MARK: - Properties
    var itemsView: ItemsView?
    var router: ItemsRouter?
    var interactor: ItemsInteractor?
    
    private var items: [String] = []
    
}

extension ItemsViewController: ItemsPresenterOutput {
    
    func presenter(didRetrieveItems items: [String]) {
        self.items = items
        self.itemsView?.reloadTableView()
    }
    
    func presenter(didFailRetrieveItems message: String) {
        showError(with: message)
    }
    
    func presenter(didObtainItem item: Item) {
        self.router?.routeToDetail(with: item)
    }
    
    func presenter(didFailObtainItemId message: String) {
        showError(with: message)
    }
    
}

// MARK: - UITableView DataSource & Delegate
extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        self.items.isEmpty ?
        self.itemsView?.showPlaceholder() :
        self.itemsView?.hidePlaceholder()
        
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = self.items[indexPath.row]
        cell.selectionStyle = .none
        
//        interactor?.cellForRowCallback(at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.interactor?.didSelectRow(at: indexPath.row)
    }
}

