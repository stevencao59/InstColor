//
//  ConfigurationManager.swift
//  InstColor
//
//  Created by Lei Cao on 1/6/23.
//

import SwiftUI
import Foundation
import RevenueCat

func configureRevenueCat() {
    Purchases.logLevel = .debug
    
    Purchases.configure(
        with: Configuration.Builder(withAPIKey: revenueCatApiKey)
            .with(usesStoreKit2IfAvailable: true)
            .build()
        )
    
    Purchases.shared.delegate = PurchasesDelegateHandler.shared
}

extension View {
    func getOfferings () -> some View {
        self
            .task {
            do {
                RevenueViewModel.shared.offerings = try await Purchases.shared.offerings()
            } catch {
                print("Error fetching offers: \(error)")
            }
        }
    }
}

