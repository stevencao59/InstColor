//
//  ThumbnailView.swift
//  InstColor
//
//  Created by Lei Cao on 10/12/22.
//

import SwiftUI

struct ThumbView: View {
    @ObservedObject var model: ContentViewModel
    @State private var viewXOffset = 100.0
    
    var body: some View {
        VStack {
            HStack {
                if let frame = model.thumbFrame {
                    Image(frame, scale: 1, label: Text("Thumbview Feed"))
                        .scaledToFit()
                        .border(.yellow)
                }
            }
            .offset(x: viewXOffset, y: 0)
            .animation(.spring(dampingFraction: 1.0), value: viewXOffset)
        }
        .padding()
        .onChange(of: model.thumbFrame) { value in
            viewXOffset = model.frameSource == .thumbImage ? 0 : 100.0
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbView(model: ContentViewModel())
    }
}
