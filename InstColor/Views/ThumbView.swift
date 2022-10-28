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
        VStack {
            if let frame = model.thumbFrame {
                Image(frame, scale: 1, label: Text("Thumbview Feed"))
                    .scaledToFit()
                    .border(.yellow)
            }
        }
        .opacity(thumbViewOpacity)
        .animation(.default, value: thumbViewOpacity)
        .onReceive(model.$thumbFrame) { _ in
            thumbViewOpacity = model.frameSource == .thumbImage ? 1 : 0
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbView(model: ContentViewModel())
    }
}
