//
//  ErrorView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

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
            ZStack {
                if let error = error {
                    Text(error.localizedDescription)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                else {
                    HStack {
                        FrameSourceView(frameSource: $frameSource, navigationHeight: $navigationHeight, imageName: $imageName)
                        HStack {
                            Menu {
                                Button(action: changeFrameSource) {
                                    HStack {
                                        Text("Full Screen")
                                        Image(systemName: "viewfinder")
                                    }
                                    .foregroundColor(.yellow)
                                }
                                Button(action: changeFrameSource) {
                                    HStack {
                                        Text("Rectagle View")
                                        Image(systemName: "viewfinder.circle")
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("Camera")
                                    Image(systemName: "chevron.down")
                                }
                                .foregroundColor(.yellow)
                            }
                            .foregroundColor(.yellow)
                            .font(.headline)
                            .padding([.vertical])
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(error == nil ? Color.black : Color.red)
            
            Spacer()
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
      NavigationView(error: CameraError.cannotAddInput, frameSource: .constant(.thumbImage), navigationHeight: .constant(1.0))
  }
}
