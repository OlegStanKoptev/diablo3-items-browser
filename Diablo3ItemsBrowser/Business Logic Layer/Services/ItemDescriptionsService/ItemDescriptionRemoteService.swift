//
//  ItemDescriptionRemoteService.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation
import CoreData

struct ItemDescriptionRemoteServiceImplementation: ItemDescriptionService {
    
    var managedContext: NSManagedObjectContext {
        guard let managedContext = CoreDataStore.managedObjectContext else {
            preconditionFailure("Cannot get managed context")
        }
        return managedContext
    }
    
    func getItemDescription(of type: String, onSuccess: @escaping (ItemDescriptionAPI) -> Void, onFailure: @escaping (String) -> Void) {
        APIClient.shared.get(from: "item-type/\(type)") { result in
            switch result {
            case .success(let data):
                self.parse(ItemDescriptionAPI.self, data: data) { res in
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
    
    private func parse<T: Decodable>(_ givenType: T.Type, data: Data, callback: @escaping (Result<T, Error>) -> Void) {
        callback(Result { try JSONDecoder().decode(T.self, from: data) })
    }
    
}
