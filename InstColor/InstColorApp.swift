//
//  InstColorApp.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI
import Firebase
import AppTrackingTransparency
import GoogleMobileAds

@main
struct InstColorApp: App {
    
    init() {
        FirebaseApp.configure()
        initiateAdmob()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
