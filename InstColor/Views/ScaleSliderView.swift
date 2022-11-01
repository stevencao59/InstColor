//
//  ViewScaleView.swift
//  InstColor
//
//  Created by Lei Cao on 10/28/22.
//

import SwiftUI

struct ScaleSliderView: View {
    @Binding var sizeWeight: CGFloat
    var range = CGFloat(0.5)...3.0
    
    var body: some View {
        HStack {
            Text("Extract Size")
            Slider(value: $sizeWeight, in: range)
                .padding([.leading])
        }
        .tint(.yellow)
        .padding()
    }
}

struct ViewScaleView_Previews: PreviewProvider {
    static var previews: some View {
        ScaleSliderView(sizeWeight: .constant(1.0))
    }
}
