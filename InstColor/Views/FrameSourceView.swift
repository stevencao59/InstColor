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
    
    var thumbviewColor: Color {
        frameSource == .wholeImage ? .white : .yellow
    }

    func changeFrameSource() {
        frameSource = frameSource == .thumbImage ? .wholeImage : .thumbImage
    }
    
    var body: some View {
        VStack() {
            Button(action: changeFrameSource) {
                Image(systemName: "viewfinder")
                    .foregroundColor(thumbviewColor)
            }
        }
        .background(.black)
        .opacity(0.8)
        .animation(.easeIn, value: thumbviewColor)
        .overlay(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        navigationHeight = geo.size.height
                    }
            }
        )
    }
}

struct FrameSourceView_Previews: PreviewProvider {
    static var previews: some View {
        FrameSourceView(frameSource: .constant(.wholeImage), navigationHeight: .constant(1.0))
    }
}
