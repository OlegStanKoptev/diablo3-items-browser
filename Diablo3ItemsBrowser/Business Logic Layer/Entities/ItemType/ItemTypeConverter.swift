//
//  ItemTypeConverter.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation

struct ItemTypeConverter {
    static func convert(toStorable itemTypesAPI: [ItemTypeAPI]) -> [ItemType] {
        let context = CoreDataStore.managedObjectContextThrowable
        return itemTypesAPI.map { itemTypeAPI in
            let itemType = ItemType(context: context)
            
            itemType.id = itemTypeAPI.id
            itemType.name = itemTypeAPI.name
            itemType.path = itemTypeAPI.path
            
            return itemType
        }
    }
    
    static func convert(toCodable itemTypes: [ItemType]) -> [ItemTypeAPI] {
        itemTypes.compactMap {
            if let id = $0.id, let name = $0.name, let path = $0.path {
                return ItemTypeAPI(
                    id: id,
                    name: name,
                    path: path
                )
            }
            return nil
        }
    }
}
