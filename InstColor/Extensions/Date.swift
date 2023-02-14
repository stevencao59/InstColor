//
//  Date.swift
//  InstColor
//
//  Created by Lei Cao on 2/11/23.
//

import Foundation

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}
