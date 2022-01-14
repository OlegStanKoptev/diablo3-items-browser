//
//  CoreDataStore.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import UIKit
import CoreData

class CoreDataStore {
    
    static var persistentContainer: NSPersistentContainer?
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            return appDelegate.persistentContainer.persistentStoreCoordinator
//        }
//        return nil
        return persistentContainer?.persistentStoreCoordinator
    }
    
    static var managedObjectModel: NSManagedObjectModel? {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            return appDelegate.persistentContainer.managedObjectModel
//        }
//        return nil
        return persistentContainer?.managedObjectModel
    }
    
    static var managedObjectContext: NSManagedObjectContext? {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            return appDelegate.persistentContainer.viewContext
//        }
//        return nil
        return persistentContainer?.viewContext
    }
    
    static var managedObjectContextThrowable: NSManagedObjectContext {
        guard let managedContext = CoreDataStore.managedObjectContext else {
            preconditionFailure("Cannot get managed context")
        }
        return managedContext
    }
    
    static func save(message: String = "") {
        do {
            try managedObjectContext?.save()
            // print("save in core data success \(message)")
        } catch {
            print("save in core data error \(message)")
            print(error.localizedDescription)
        }
    }
    
}

