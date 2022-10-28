//
//  MenuOptionView.swift
//  InstColor
//
//  Created by Lei Cao on 10/26/22.
//

import SwiftUI

struct NavigationMenuLabel: View {
    let text: String
    let condition: () -> Bool
    
    init(text: String, condition: @escaping () -> Bool) {
        self.text = text
        self.condition = condition
    }
    
    var body: some View {
        HStack {
            Text(text)
            if condition() {
                Image(systemName: "checkmark")
            }
        }
    }
}

struct NavigationMenuView: View {
    @Binding var frameSource: FrameSource
    @Binding var thumbFrameSize: ThumbFrameSize
    
    func changeToWholeImage() {
        frameSource = .wholeImage
    }
    
    func changeToThumbImage(action: @escaping () -> Void) {
        frameSource = .thumbImage
        action()
    }
    
    init (frameSource: Binding<FrameSource>, thumbFrameSize: Binding<ThumbFrameSize>) {
        self._frameSource = frameSource
        self._thumbFrameSize = thumbFrameSize
    }
    
    var body: some View {
        Menu {
            Button(action: changeToWholeImage) {
                NavigationMenuLabel(text: "Full Screen") {
                    frameSource == .wholeImage
                }
            }

            Button(action: {changeToThumbImage { () in thumbFrameSize = .halfSize}}) {
                NavigationMenuLabel(text: "Rectagle View x 0.5") {
                    frameSource == .thumbImage && thumbFrameSize == .halfSize
                }
            }
            
            Button(action: {changeToThumbImage { () in thumbFrameSize = .defaultSize}}) {
                NavigationMenuLabel(text: "Rectagle View x 1") {
                    frameSource == .thumbImage && thumbFrameSize == .defaultSize
                }
            }
            
            Button(action: {changeToThumbImage { () in thumbFrameSize = .doubleSize}}) {
                NavigationMenuLabel(text: "Rectagle View x 2") {
                    frameSource == .thumbImage  && thumbFrameSize == .doubleSize
                }
            }
        } label: {
            HStack {
                Text("Camera")
                Image(systemName: "chevron.down")
            }
        }
        .font(.headline)
        .padding([.vertical])
    }
}

struct NavigationMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMenuView(frameSource: .constant(.thumbImage), thumbFrameSize: .constant(.defaultSize))
    }
}
