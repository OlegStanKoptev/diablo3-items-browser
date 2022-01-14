//
//  ItemDescriptionAPI.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 14.01.2022.
//

import Foundation

struct ItemDescriptionAPI: Codable {
    var id: String
    var slug: String?
    var name: String?
    var icon: String?
    var tooltipParams: String?
    var requiredLevel: Int?
    var stackSizeMax: Int?
    var accountBound: Bool?
    var flavorText: String?
    var flavorTextHtml: String?
    var typeName: String?
    struct `Type`: Codable {
        var twoHanded: Bool?
        var id: String?
    }
    var type: `Type`?
    var damage: String?
    var dps: String?
    var damageHtml: String?
    var armor: String?
    var armorHtml: String?
    var color: String?
    var isSeasonRequiredToDrop: Bool?
    var seasonRequiredToDrop: Int?
    var slots: [String]?
    struct TextHtmlProperty: Codable {
        var textHtml: String?
        var text: String?
    }
    struct Attributes: Codable {
        var primary: [TextHtmlProperty]?
        var secondary: [TextHtmlProperty]?
        var other: [TextHtmlProperty]?
    }
    var attributes: Attributes?
    struct Affix: Codable {
        var oneOf: [TextHtmlProperty]?
    }
    var randomAffixes: [Affix]?
    var setName: String?
    var setNameHtml: String?
    var setDescription: String?
    var setDescriptionHtml: String?
    var setItems: [String]?
    
    static var keyPaths: [PartialKeyPath<ItemDescriptionAPI>] = [
        //        \.id,
        //        \.slug,
        \.name,
         //        \.icon,
         //        \.tooltipParams,
         \.requiredLevel,
         \.stackSizeMax,
         \.accountBound,
         \.flavorText,
         //        \.flavorTextHtml,
         \.typeName,
         \.type,
         \.damage,
         \.dps,
         //        \.damageHtml,
         \.armor,
//                 \.armorHtml,
         \.color,
         \.isSeasonRequiredToDrop,
         \.seasonRequiredToDrop,
         \.slots,
         \.attributes,
         \.randomAffixes,
         \.setName,
         //        \.setNameHtml,
         \.setDescription,
         //        \.setDescriptionHtml,
         \.setItems,
    ]
}
