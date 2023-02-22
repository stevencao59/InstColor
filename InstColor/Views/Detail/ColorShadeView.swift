//
//  ColorShadeView.swift
//  InstColor
//
//  Created by Lei Cao on 11/26/22.
//

import SwiftUI

struct ColorValuePair: Identifiable, Equatable {
    let id = UUID()
    var color: Color
    var value: Double
}

struct ShadeView: View {
    @Binding var referenceColor: UIColor

    var shadeColor: UIColor
    var colorName: String {
        let name = shadeColor.calculateClosestColor(colorMap: Settings.shared.colorMap)
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
    var colorValuePairs: [ColorValuePair]
    
    var body: some View {
        GridRow {
            VStack {
                HStack {
                    if let referenceColor {
                        ForEach(1...4, id: \.self) { i in
                            let color = colorValuePairs.reduce(referenceColor) { $0.combine(with: UIColor($1.color), amount: $1.value * Double(i)) }
                            ShadeView(referenceColor: $referenceColor, shadeColor: color)
                        }
                    }
                }
            }
        }
    }
}

struct ColorPickerView: View {
    @Binding var pairs: [ColorValuePair]
    
    var index: Int? {
        if let item = pairs.first(where: { $0.id == pickerId}) {
            return pairs.firstIndex(of: item)
        }
        return nil
    }
    
    let pickerId: UUID
    let viewSize: CGFloat
    let shadeRange: ClosedRange<Double>
    
    func remove() {
        if let index {
            pairs.remove(at: index)
        }
    }
    
    var body: some View {
        HStack {
            if let index {
                if pairs.count > 1 {
                    Button(action: remove) {
                        ImageButtonView(imageName: "minus.circle")
                    }
                }
                ColorPicker("", selection: $pairs[index].color, supportsOpacity: false)
                    .frame(width: viewSize)
                    .padding(.horizontal)
                Slider(value: $pairs[index].value, in: shadeRange)
                Text("\(String(format: "%.0f%%", pairs[index].value / shadeRange.upperBound * 100))")
                Stepper("", value: $pairs[index].value, in: shadeRange, step: shadeRange.upperBound / 100)
                    .labelsHidden()
                    .foregroundColor(.white)
                    .tint(.white)
            }
        }
    }
}

struct ColorShadeView: View {
    @Binding var referenceColor: UIColor
    @State var colorValuePairs: [ColorValuePair] = [ColorValuePair(color: .white, value: 0.0)]

    let colorViewSize: CGFloat = UIScreen.screenHeight / defaultScreenHeight * 20
    let shadeRange = 0.0...0.3
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Group {
                        if colorValuePairs.count < 4 {
                            Button(action: { colorValuePairs.append(ColorValuePair(color: .white, value: 0.0)) }) {
                                ImageButtonView(imageName: "plus")
                            }
                        }
                    }
                    .padding([.trailing])
                }
                
                ForEach(colorValuePairs) { item in
                    ColorPickerView(pairs: $colorValuePairs, pickerId: item.id, viewSize: colorViewSize, shadeRange: shadeRange)
                        .padding([.bottom])
                }
            }

            Grid {
                ShadeRowView(referenceColor: $referenceColor, colorValuePairs: colorValuePairs)
            }
            
            Text("You can blend custom colors (up to 4) with color you just detected.")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()
        }
        .foregroundColor(.white)
        .animation(.default, value: colorValuePairs)
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
