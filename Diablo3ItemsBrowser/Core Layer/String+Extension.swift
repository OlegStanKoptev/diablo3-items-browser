//
//  String+Extension.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 29.12.2021.
//

import Foundation

extension String {
    var secondComponent: String? {
        let components = self.components(separatedBy: "/")
        if components.count > 1 { return components[1] }
        return nil
    }
}
