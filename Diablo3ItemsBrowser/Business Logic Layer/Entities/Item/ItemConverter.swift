//
//  ItemConverter.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 28.12.2021.
//

import Foundation

/*
 struct ItemAPI: Codable {
 var id: String
 var slug: String
 var name: String
 var icon: String
 var path: String
 }

 */

struct ItemConverter {
    static func convert(toStorable itemsAPI: [ItemAPI], with type: String) -> [Item] {
        let context = CoreDataStore.managedObjectContextThrowable
        return itemsAPI.map { itemAPI in
            //
            #warning("TODO: Fix race condition (sometimes app crashes when loading from server)")
            // when item is created while we count existing items
            // maybe the new context has to be created for current thread
            // even though this piece of code is run from the main thread
            let item = Item(context: context)
            
            item.id = itemAPI.id
            item.slug = itemAPI.slug
            item.name = itemAPI.name
            item.icon = itemAPI.icon
            item.path = itemAPI.path
            item.itemType = type
            
            return item
        }
    }
    
    static func convert(toCodable items: [Item]) -> [ItemAPI] {
        items.compactMap {
            if let id = $0.id,
               let name = $0.name,
               let path = $0.path,
               let icon = $0.icon,
               let slug = $0.slug {
                return ItemAPI(
                    id: id,
                    slug: slug,
                    name: name,
                    icon: icon,
                    path: path
                )
            }
            return nil
        }
    }
}
