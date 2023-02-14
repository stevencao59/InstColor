//
//  Crud.swift
//  InstColor
//
//  Created by Lei Cao on 2/13/23.
//

import Foundation
import SwiftUI

func saveFavoriteColor(color: UIColor) {
    var savedColors = UserDefaults.standard.readColor(forKey: favoritColorKey) ?? []
    savedColors.append(FavoriteColor(id: UUID().uuidString, red: Int(color.components.red * 255), green: Int(color.components.green * 255), blue: Int(color.components.blue * 255), createdDate: Date()))
    UserDefaults.standard.setColor(savedColors, forKey: favoritColorKey)
}
