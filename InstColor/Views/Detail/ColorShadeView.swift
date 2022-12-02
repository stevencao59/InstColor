//
//  ColorShadeView.swift
//  InstColor
//
//  Created by Lei Cao on 11/26/22.
//

import SwiftUI

struct ShadeView: View {
    @Binding var referenceColor: UIColor
    var shadeColor: UIColor
    var colorName: String {
        let name = shadeColor.calculateClosestColor()
        return name?.English ?? "Unknown Color"
    }
    
    func selectColor() {
        referenceColor = shadeColor
    }
    
    var body: some View {
        Button(action: selectColor) {
            VStack {
                BorderedRectView(color: Color(shadeColor), cornerRadius: 30, lineWidth: 1, width: 40, height: 40)
                Text(colorName)
                    .lineLimit(1, reservesSpace: false)
                    .font(.footnote)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ShadeRowView: View {
    @Binding var referenceColor: UIColor
    var sliderValue: Double
    var title: String
    var combineColor: UIColor
    
    var body: some View {
        GridRow {
            VStack {
                Text(title)
                    .font(.headline)
                    .bold(true)
                    .padding([.top])
                HStack {
                    if let referenceColor {
                        ForEach(1...4, id: \.self) { i in
                            ShadeView(referenceColor: $referenceColor, shadeColor: referenceColor.combine(with: combineColor, amount: sliderValue * Double(i)))
                        }
                    }
                }
            }
        }
    }
}

struct ColorShadeView: View {
    @Binding var referenceColor: UIColor
    @State var sliderValue = 0.15
    
    var body: some View {
        VStack {
            Text("Shade Amount")
                .font(.headline)
                .bold(true)
                .padding([.top])
            Slider(value: $sliderValue, in: 0.1...0.3)
                .padding([.top, .horizontal])
            ScrollView {
                Grid {
                    ShadeRowView(referenceColor: $referenceColor, sliderValue: sliderValue, title: "Light Shades", combineColor: .white)
                    ShadeRowView(referenceColor: $referenceColor, sliderValue: sliderValue, title: "Dark Shades", combineColor: .black)
                }
            }
        }
        .foregroundColor(.white)
    }
}

struct ColorShadeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ColorShadeView(referenceColor: .constant(.red))
        }
    }
}
