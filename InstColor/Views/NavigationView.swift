//
//  ErrorView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct NavigationMenu: View {
    let action: () -> Void
    var frameSource: FrameSource
    
    init (action: @escaping () -> Void, frameSource: FrameSource) {
        self.action = action
        self.frameSource = frameSource
    }
    
    var body: some View {
        Menu {
            Button(action: action) {
                HStack {
                    Text("Full Screen")
                    if frameSource == .wholeImage {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button(action: action) {
                HStack {
                    Text("Rectagle View")
                    if frameSource == .thumbImage {
                        Image(systemName: "checkmark")
                    }
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

struct NavigationView: View {
    var error: Error?
    @Binding var frameSource: FrameSource
    @Binding var navigationHeight: CGFloat
    
    @State var imageName = "viewfinder"
    
    func changeFrameSource() {
        frameSource = frameSource == .thumbImage ? .wholeImage : .thumbImage
    }
    
    var body: some View {
        VStack {
            HStack {
                if let error = error {
                    Text(error.localizedDescription)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    FrameSourceView(frameSource: $frameSource, imageName: $imageName)
                    NavigationMenu(action: changeFrameSource, frameSource: frameSource)
                }
            }
            .frame(maxWidth: .infinity)
            .background(.black)
            .opacity(0.9)
            .foregroundColor(.yellow)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            navigationHeight = geo.size.height
                        }
                }
            )
            Spacer()
            
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationView(error: nil, frameSource: .constant(.thumbImage), navigationHeight: .constant(1.0))
  }
}
