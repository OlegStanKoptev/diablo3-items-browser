//
//  ItemTypesViewController.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import UIKit

protocol ItemTypesPresenterOutput: AnyObject {
    func presenter(didRetrieveItems items: [String])
    func presenter(didFailRetrieveItems message: String)
    
    func presenter(didRetrieveItem item: String, for index: Int)
    
    func presenter(didObtainItemType itemType: ItemType)
    func presenter(didFailObtainItemType message: String)
}

class ItemTypesViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
        self.view = typesView
        
        typesView?.tableView.delegate = self
        typesView?.tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "D3 Items Browser"
    }
    
    // MARK: - Actions
    // nothing yet
    func showError(with message: String) {
        NSLog(message)
    }
    
    // MARK: - Properties
    var typesView: ItemTypesView?
    var router: ItemTypesRouter?
    var interactor: ItemTypesInteractor?
    
    private var items: [String] = []
    
}

extension ItemTypesViewController: ItemTypesPresenterOutput {
    
    func presenter(didRetrieveItems items: [String]) {
        self.items = items
        self.typesView?.reloadTableView()
    }
    
    func presenter(didFailRetrieveItems message: String) {
        showError(with: message)
    }
    
    func presenter(didRetrieveItem item: String, for index: Int) {
        self.items[index] = item
        DispatchQueue.main.async {
            self.typesView?.updateRow(at: index)
        }
    }
    
    func presenter(didObtainItemType itemType: ItemType) {
        self.router?.routeToDetail(with: itemType)
    }
    
    func presenter(didFailObtainItemType message: String) {
        showError(with: message)
    }
    
}

// MARK: - UITableView DataSource & Delegate
extension ItemTypesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        self.items.isEmpty ?
        self.typesView?.showPlaceholder() :
        self.typesView?.hidePlaceholder()
        
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = self.items[indexPath.row]
        cell.selectionStyle = .none
        
        interactor?.cellForRowCallback(at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.interactor?.didSelectRow(at: indexPath.row)
    }
}

