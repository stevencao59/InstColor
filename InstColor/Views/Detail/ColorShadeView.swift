//
//  ColorShadeView.swift
//  InstColor
//
//  Created by Lei Cao on 11/26/22.
//

import SwiftUI

struct ShadeView: View {
    @Binding var referenceColor: UIColor
    
    let colorMap: [RGBColor]

    var shadeColor: UIColor
    var colorName: String {
        let name = shadeColor.calculateClosestColor(colorMap: colorMap)
        return name.Color
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
    
    let colorMap: [RGBColor]

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
                            ShadeView(referenceColor: $referenceColor, colorMap: colorMap, shadeColor: referenceColor.combine(with: combineColor, amount: sliderValue * Double(i)))
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
    
    let colorMap: [RGBColor]
    
    let shadeViewList: [(title: String, color: UIColor)] = [
        (title: "Light Shades", color: .white),
        (title: "Dark Shades", color: .black)
    ]

    var body: some View {
        VStack {
            HStack {
                Text("Shade Amount")
                    .bold(true)
                Slider(value: $sliderValue, in: 0.1...0.3)
            }
            .padding([.horizontal])
            
            Grid {
                ForEach(shadeViewList, id: \.title) { shadeView in
                    ShadeRowView(referenceColor: $referenceColor, sliderValue: sliderValue, title: shadeView.title, combineColor: shadeView.color, colorMap: colorMap)
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
            ColorShadeView(referenceColor: .constant(.red), colorMap: [])
        }
    }
}
