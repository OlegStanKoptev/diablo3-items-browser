//
//  ItemDescriptionViewController.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import UIKit

protocol ItemDescriptionPresenterOutput: AnyObject {
    func presenter(didRetrieveItemDescription ItemDescription: [String])
    func presenter(didFailRetrieveItemDescription message: String)
    
//    func presenter(didObtainItemId id: String)
//    func presenter(didFailObtainItemId message: String)
}

class ItemDescriptionViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        super.loadView()
        self.view = itemDescriptionView
        
        itemDescriptionView?.tableView.delegate = self
        itemDescriptionView?.tableView.dataSource = self
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
    var itemDescriptionView: ItemDescriptionView?
    var router: ItemDescriptionRouter?
    var interactor: ItemDescriptionInteractor?
    
    private var itemDescription: [String] = []
    
}

extension ItemDescriptionViewController: ItemDescriptionPresenterOutput {
    
    func presenter(didRetrieveItemDescription ItemDescription: [String]) {
        self.itemDescription = ItemDescription
        self.itemDescriptionView?.reloadTableView()
    }
    
    func presenter(didFailRetrieveItemDescription message: String) {
        showError(with: message)
    }
    
//    func presenter(didObtainItemId id: String) {
//        self.router?.routeToDetail(with: id)
//    }
//
//    func presenter(didFailObtainItemId message: String) {
//        showError(with: message)
//    }
    
}

// MARK: - UITableView DataSource & Delegate
extension ItemDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        self.itemDescription.isEmpty ?
        self.itemDescriptionView?.showPlaceholder() :
        self.itemDescriptionView?.hidePlaceholder()
        
        return self.itemDescription.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = self.itemDescription[indexPath.row]
        cell.selectionStyle = .none
        
//        interactor?.cellForRowCallback(at: indexPath.row)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.interactor?.didSelectRow(at: indexPath.row)
//    }
}

