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
            FrameView(image: model.frame)
                .edgesIgnoringSafeArea(.all)
            
            ErrorView(error: model.error)
            
            if let color = model.averageColor {
                HStack{
                    ColorResultView(color: color)
                    Spacer()
                    HStack {
                        ColorTextView(iconColor: .red, displayColor: color.components.red)
                        ColorTextView(iconColor: .green, displayColor: color.components.green)
                        ColorTextView(iconColor: .blue, displayColor: color.components.blue)
                    }
                }
                .padding()
                .offset(x: -5, y: -5)
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
