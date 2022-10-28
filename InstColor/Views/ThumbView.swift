//
//  ThumbnailView.swift
//  InstColor
//
//  Created by Lei Cao on 10/12/22.
//

import SwiftUI

struct ThumbView: View {
    @ObservedObject var model: ContentViewModel
    @State private var thumbViewOpacity = 1.0
        
    var body: some View {
        if let rect = model.rect {
            if let frame = model.thumbFrame {
                VStack {
                    Image(frame, scale: 1, label: Text("Thumbview Feed"))
                        .resizable()
                        .scaledToFit()
                        .border(.yellow)
                }
                .frame(width: rect.width)
                .opacity(thumbViewOpacity)
                .animation(.default, value: thumbViewOpacity)
                .animation(.default, value: rect.width)
                .scaleEffect(model.scaleAmount)
                .offset(CGSize(width: rect.origin.x, height: rect.origin.y))
                .onReceive(model.$thumbFrame) { _ in
                    thumbViewOpacity = model.frameSource == .thumbImage ? 1 : 0
                }
                .onChange(of: rect) { _ in
                    withAnimation() {
                        model.scaleAmount = 1.5
                    }
                }
                .onAppear() {
                    withAnimation() {
                        model.scaleAmount = 1.5
                    }
                }
            }
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbView(model: ContentViewModel())
    }
}
