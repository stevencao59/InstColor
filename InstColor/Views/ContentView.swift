//
//  ContentView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = ContentViewModel()
    
    var body: some View {
        ContentContainerView(model: model) {
            ZStack(alignment: .bottomTrailing) {
                FrameView(model: model)
                    .overlay(ThumbView(model: model), alignment: .topLeading)
                NavigationView(model: model)
                DashboardView(model: model)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
