//
//  ItemAPI.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 28.12.2021.
//

import Foundation

struct ItemAPI: Codable {
    var id: String
    var slug: String
    var name: String
    var icon: String
    var path: String
}
