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
            FrameView(image: model.frame, location: $model.location, rectSize: $model.size)
                .overlay(RectangleView(rect: model.rect), alignment: .topLeading)
            NavigationView(error: model.error)
            DashboardView(color: model.averageColor)
                .overlay(ThumbView(frame: model.thumbFrame, location: model.location), alignment: .topTrailing)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
