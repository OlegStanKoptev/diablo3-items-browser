//
//  ItemDescriptionService.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation
import CoreData

struct ItemDescriptionLocalServiceImplementation: ItemDescriptionService {
    
    var managedContext: NSManagedObjectContext {
        guard let managedContext = CoreDataStore.managedObjectContext else {
            preconditionFailure("Cannot get managed context")
        }
        return managedContext
    }
    
    func getItemDescription(of type: String, onSuccess: @escaping (ItemDescription) -> Void, onFailure: @escaping (String) -> Void) {
        let fetchRequest = ItemDescription.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "itemType == %@", type)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let itemDesc = try managedContext.fetch(fetchRequest)
            if let description = itemDesc.first {
                onSuccess(description)
            } else {
                onFailure("core data: fetch request success but found none")
            }
        } catch {
            onFailure("core data: fetch request fail, \(error.localizedDescription)")
        }
    }
    
    func getItemDescriptionQnt(of type: String, onSuccess: @escaping (Int) -> Void, onFailure: @escaping (String) -> Void) {
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "itemType == %@", type)
        fetchRequest.includesSubentities = false
        
        do {
            onSuccess(try managedContext.count(for: fetchRequest))
        } catch {
            onFailure("core data: fetch request fail, \(error.localizedDescription)")
        }
    }
    
    
//    func getItem(with id: String, onSuccess: @escaping (Item?) -> Void, onFailure: @escaping (String) -> Void) {
//        let predicate = NSPredicate(format: "id = %@", id)
//        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemType")
//        fetchRequest.predicate = predicate
//        
//        do {
//            let result = try managedContext.fetch(fetchRequest)
//            
//            if let item = result.first as? Item  {
//                onSuccess(item)
//            }
//        } catch {
//            print("Couldn't get item type")
//            onFailure(error.localizedDescription)
//        }
//    }
    
}
