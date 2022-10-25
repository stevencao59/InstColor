//
//  FrameSourceView.swift
//  InstColor
//
//  Created by Lei Cao on 10/18/22.
//

import SwiftUI

struct FrameSourceView: View {
    @Binding var frameSource: FrameSource
    @Binding var navigationHeight: CGFloat
    @Binding var imageName: String

    func changeFrameSource() {
        frameSource = frameSource == .thumbImage ? .wholeImage : .thumbImage
    }
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
        }
        .background(.black)
        .foregroundColor(.yellow)
        .opacity(0.8)
        .overlay(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        navigationHeight = geo.size.height
                    }
            }
        )
        .animation(.easeIn, value: imageName)
        .onChange(of: frameSource) { newSurce in
            imageName = newSurce == .thumbImage ? "viewfinder.circle" : "viewfinder"
        }
    }
}

struct FrameSourceView_Previews: PreviewProvider {
    static var previews: some View {
        FrameSourceView(frameSource: .constant(.wholeImage), navigationHeight: .constant(1.0), imageName: .constant("viewfinder"))
    }
}
