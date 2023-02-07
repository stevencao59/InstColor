//
//  ThumbnailView.swift
//  InstColor
//
//  Created by Lei Cao on 10/12/22.
//

import SwiftUI

struct ThumbView: View {
    @ObservedObject var model: ContentViewModel
    @State private var thumbViewOpacity = 0.0
    @State private var phase = 0.0

    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil
    
    let StrokeBorder: some View = Rectangle()
        .strokeBorder(style: StrokeStyle())
    
    var orientation: Image.Orientation {
        return model.cameraManager.cameraPosition == .front ? .upMirrored : .up
    }
    
    var dragGesutre: some Gesture {
        DragGesture()
            .onChanged { value in
                if let location = model.location {
                    var newLocation = startLocation ?? location
                    newLocation.x += value.translation.width
                    newLocation.y += value.translation.height
                    model.location = newLocation
                }
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? model.location
            }
    }
    
    var fingerDragGesture: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
    }
    
    var body: some View {
        if let rect = model.rect {
            if let frame = model.thumbFrame {
                ZStack {
                    Image(frame, scale: 1, orientation: orientation, label: Text("Thumbview Feed"))
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                    StrokeBorder
                        .frame(width: rect.width, height: rect.height)
                        .foregroundColor(.white)
                    StrokeBorder
                        .frame(width: rect.width + 1, height: rect.height + 1)
                        .foregroundColor(.black)
                }
                .frame(width: rect.width)
                .opacity(thumbViewOpacity)
                .animation(.default, value: thumbViewOpacity)
                .animation(.default, value: rect.width)
                .scaleEffect(model.scaleAmount)
                .offset(CGSize(width: rect.origin.x, height: rect.origin.y))
                .gesture(
                    dragGesutre.simultaneously(with: fingerDragGesture)
                )
                .onReceive(model.$thumbFrame) { _ in
                    thumbViewOpacity = model.frameSource == .thumbImage ? 1 : 0
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
