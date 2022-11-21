//
//  UserDefaults.swift
//  InstColor
//
//  Created by Lei Cao on 11/19/22.
//

import Foundation

extension UserDefaults {
    func readColor(forKey defaultName: String) -> [FavoriteColor]? {
        guard let data = data(forKey: defaultName) else { return nil }
        do {
            return try JSONDecoder().decode([FavoriteColor].self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func setColor(_ value: [FavoriteColor], forKey defaultName: String) {
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
}
