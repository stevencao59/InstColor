//
//  RevenueViewModel.swift
//  InstColor
//
//  Created by Lei Cao on 1/6/23.
//

import Foundation
import RevenueCat

class RevenueViewModel: ObservableObject {
    static let shared = RevenueViewModel()
    
    @Published var offerings: Offerings? = nil
    
}
