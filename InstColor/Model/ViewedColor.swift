//
//  ViewedColor.swift
//  InstColor
//
//  Created by Lei Cao on 2/9/23.
//

import Foundation

struct ViewedColor: Identifiable, Hashable {
    let id = UUID()
    let red: Double
    let green: Double
    let blue: Double
    let viewedTime: Date
}
