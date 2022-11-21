//
//  FavoriteColor.swift
//  InstColor
//
//  Created by Lei Cao on 11/19/22.
//

import Foundation

struct FavoriteColor: Codable, Identifiable {
    let id: String
    let red: Int
    let green: Int
    let blue: Int
    let createdDate: Date
}
