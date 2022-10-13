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
        ZStack(alignment: .bottomTrailing) {
            FrameView(image: model.frame, location: $model.location)
            NavigationView(error: model.error)
            DashboardView(color: model.averageColor, location: model.location)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
