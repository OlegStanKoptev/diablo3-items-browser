//
//  ItemTypesView.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

#warning("TODO: Collection view with big elements where count > 40")
import UIKit

class ItemTypesView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    public func showPlaceholder() {
        UIView.animate(withDuration: 0.3) {
            self.placeholderLabel.alpha = 1.0
            self.tableView.alpha = 0.0
        }
    }
    
    public func hidePlaceholder() {
        UIView.animate(withDuration: 0.3) {
            self.placeholderLabel.alpha = 0.0
            self.tableView.alpha = 1.0
        }
    }
    
    public func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    public func insertRow(at index: Int, section: Int = 0) {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [
            IndexPath(
                row: index,
                section: section
            )
        ], with: .automatic)
        self.tableView.endUpdates()
    }
    
    public func deleteRow(at index: Int, section: Int = 0) {
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [
            IndexPath(
                row: index,
                section: section
            )
        ], with: .automatic)
        self.tableView.endUpdates()
    }
    
    public func updateRow(at index: Int, section: Int = 0) {
        updateRows(at: [index], section: section)
    }
    
    public func updateRows(at indices: [Int], section: Int = 0) {
        self.tableView.reloadRows(at: indices.map { IndexPath(row: $0, section: section) }, with: .automatic)
    }
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 70
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 25)
        label.text = "No items yet, add one!"
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}

extension ItemTypesView {
    
    private func setupUI() {
        overrideUserInterfaceStyle = .light
        self.backgroundColor = .white
        
        self.addSubview(tableView)
        self.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
}

