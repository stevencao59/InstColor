//
//  MenuOptionView.swift
//  InstColor
//
//  Created by Lei Cao on 10/26/22.
//

import SwiftUI

struct SliderControlView: View {
    @Binding var showScaleSlider: Bool
    
    func setShowScaleSlider() {
        showScaleSlider.toggle()
    }
    
    var body: some View {
        VStack {
            Button(action: setShowScaleSlider) {
                if showScaleSlider {
                    Image(systemName: "chevron.up")
                } else {
                    Image(systemName:  "chevron.down")
                }
            }
        }
        .animation(.default, value: showScaleSlider)
    }
}

struct NavigationMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SliderControlView(showScaleSlider: .constant(false))
    }
}
