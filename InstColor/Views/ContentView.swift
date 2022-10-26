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
            FrameView(image: model.frame, navigationHeight: model.navigationHeight, dashboardHeight: model.dashboardHeight, location: $model.location, rectSize: $model.size, scaleAmount: $model.scaleAmount, frameSource: $model.frameSource)
                .overlay(RectangleView(rect: model.rect, frameSource: model.frameSource, scaleAmount: $model.scaleAmount), alignment: .topLeading)
            NavigationView(error: model.error, frameSource: $model.frameSource, navigationHeight: $model.navigationHeight)
            DashboardView(color: model.averageColor, dashboardHeight: $model.dashboardHeight)
                .overlay(ThumbView(frame: model.thumbFrame, frameSource: model.frameSource), alignment: .topTrailing)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
