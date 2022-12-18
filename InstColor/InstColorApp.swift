//
//  InstColorApp.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI
import Firebase

@main
struct InstColorApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
