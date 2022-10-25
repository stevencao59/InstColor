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
                        FrameSourceView(frameSource: $frameSource, navigationHeight: $navigationHeight)
                        Text("Camera")
                            .foregroundColor(.yellow)
                            .font(.headline)
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
