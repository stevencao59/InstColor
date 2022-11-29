//
//  ImageModifier.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI
import UIKit

struct FrameModifier: ViewModifier {
    private var contentSize: CGSize
    
    @State var currentScale: CGFloat = 1.0
    
    @Binding var rectSize: CGSize?
    @Binding var location: CGPoint?
    @Binding var scaleAmount: Double

    @Binding var frameSource: FrameSource
    
    init(contentSize: CGSize, rectSize: Binding<CGSize?>, location: Binding<CGPoint?>, frameSource: Binding<FrameSource>, scaleAmount: Binding<Double>) {
        self.contentSize = contentSize

        self._rectSize = rectSize
        self._location = location
        self._scaleAmount = scaleAmount
        
        self._frameSource = frameSource
    }
    
    var tapGesture: some Gesture {
        SpatialTapGesture().onEnded { event in
            location = event.location
            frameSource = .thumbImage
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: contentSize.width * currentScale, height: contentSize.height * currentScale, alignment: .center)
        
            .gesture(tapGesture)

            .onChange(of: currentScale) { newValue in
                rectSize = CGSize(width: contentSize.width * newValue, height: contentSize.height * newValue)
            }
            .onAppear() {
                rectSize = CGSize(width: contentSize.width, height: contentSize.height)
            }
            .animation(.easeOut, value: currentScale)
    }
    
}
