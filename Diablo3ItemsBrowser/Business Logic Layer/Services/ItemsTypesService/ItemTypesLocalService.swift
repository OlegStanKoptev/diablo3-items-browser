//
//  ItemTypesService.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation
import CoreData

struct ItemTypesLocalServiceImplementation {//: ItemTypesService {
    
    var managedContext: NSManagedObjectContext {
        guard let managedContext = CoreDataStore.managedObjectContext else {
            preconditionFailure("Cannot get managed context")
        }
        return managedContext
    }
    
    func getItemTypes(onSuccess: @escaping ([ItemType]) -> Void, onFailure: @escaping (String) -> Void) {
        let fetchRequest = ItemType.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            onSuccess(try managedContext.fetch(fetchRequest))
        } catch {
            print("Couldn't get item types")
            onFailure(error.localizedDescription)
        }
    }
    
//    func getItemType(with id: String, onSuccess: @escaping (ItemType?) -> Void, onFailure: @escaping (String) -> Void) {
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
    
}
