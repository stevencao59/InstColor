//
//  ErrorView.swift
//  InstColor
//
//  Created by Lei Cao on 9/30/22.
//

import SwiftUI

struct NavigationView: View {
  var error: Error?

  var body: some View {
    VStack {
        ZStack{
            if let error = error {
                Text(error.localizedDescription)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(error == nil ? Color.black : Color.red)
        .animation(.easeInOut, value: 0.25)

      Spacer()
    }

  }
}

struct NavigationView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView(error: CameraError.cannotAddInput)
  }
}
