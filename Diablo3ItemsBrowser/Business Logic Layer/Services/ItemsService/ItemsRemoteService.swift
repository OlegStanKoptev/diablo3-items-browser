//
//  ItemsRemoteService.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation
import CoreData

struct ItemsRemoteServiceImplementation {
    
    var managedContext: NSManagedObjectContext {
        guard let managedContext = CoreDataStore.managedObjectContext else {
            preconditionFailure("Cannot get managed context")
        }
        return managedContext
    }
    
    func getItems(of type: String, onSuccess: @escaping ([ItemAPI]) -> Void, onFailure: @escaping (String) -> Void) {
        APIClient.shared.get(from: "item-type/\(type)") { result in
            switch result {
            case .success(let data):
                self.parse([ItemAPI].self, data: data) { res in
                    switch res {
                    case .success(let arr):
                        onSuccess(arr)
                    case .failure(let err):
                        onFailure(err.localizedDescription)
                    }
                }
            case .failure(let err):
                onFailure(err.localizedDescription)
            }
        }
    }
    
    func getItemsQnt(of type: String, onSuccess: @escaping (Int) -> Void, onFailure: @escaping (String) -> Void) {
        fatalError()
    }
    
    
//    func getItem(from path: String, with id: String, onSuccess: @escaping (Item?) -> Void, onFailure: @escaping (String) -> Void) {
//        let predicate = NSPredicate(format: "id = %@", id)
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemType")
//        fetchRequest.predicate = predicate
//
//        do {
//            let result = try managedContext.fetch(fetchRequest)
//
//            if let itemType = result.first as? ItemType  {
//                onSuccess(itemType)
//            }
//        } catch {
//            print("Couldn't get item type")
//            onFailure(error.localizedDescription)
//        }
//    }
    
    private func parse<T: Decodable>(_ givenType: T.Type, data: Data, callback: @escaping (Result<T, Error>) -> Void) {
        callback(Result { try JSONDecoder().decode(T.self, from: data) })
    }
    
}
