//
//  ColorDetailView.swift
//  InstColor
//
//  Created by Lei Cao on 11/5/22.
//

import SwiftUI

struct ColorSliderView: View {
    @Binding var colorValue: Double
    @Binding var color: UIColor
    
    var containerCotentWidth: Double
    var iconColor: Color
    
    let range = 1.0...255.0
    
    init(colorValue: Binding<Double>, color:Binding<UIColor>, containerCotentWidth: Double, iconColor: Color) {
        self._colorValue = colorValue
        self._color = color
        
        self.containerCotentWidth = containerCotentWidth
        self.iconColor = iconColor
        
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(iconColor)
                .frame(width: containerCotentWidth * 0.05)
            Spacer()
            Text("\("\(String(format: "%.0f", colorValue))")")
                .frame(width: containerCotentWidth * 0.2)
            HStack {
                Slider(value: $colorValue, in: range)
                    .frame(width: containerCotentWidth * 0.4)
                Stepper("", value: $colorValue, in: range)
                    .foregroundColor(.white)
                    .tint(.white)
            }
        }
        .padding([.horizontal])
        .foregroundColor(.white)
        .frame(width: containerCotentWidth)
        .onChange(of: colorValue) { value in
            if iconColor == Color(.red) {
                color = UIColor(red: Int(colorValue), green: Int(color.components.green * 255), blue: Int(color.components.blue * 255))
            } else if iconColor == Color(.green) {
                color = UIColor(red: Int(color.components.red * 255), green: Int(colorValue), blue: Int(color.components.blue * 255))
            } else if iconColor == Color(.blue) {
                color = UIColor(red: Int(color.components.red * 255), green: Int(color.components.green * 255), blue: Int(colorValue))
            }
        }
    }
}

struct ColorDetailView: View {
    
    @Binding var showColorDetail: Bool
    @State var color: UIColor
    @State var colorName: String

    @State var red: Double
    @State var green: Double
    @State var blue: Double
    
    var containerCotentWidth: Double
    
    init(color: UIColor, colorName: String, containerCotentWidth: Double, showColorDetail: Binding<Bool>) {
        self.color = color
        self.colorName = colorName

        self.red = Double(color.components.red * 255)
        self.green = Double(color.components.green * 255)
        self.blue = Double(color.components.blue * 255)
        
        self.containerCotentWidth = containerCotentWidth
        
        self._showColorDetail = showColorDetail
    }
    
    func toggleSheet() {
        showColorDetail.toggle()
    }
    
    var body: some View {
        VStack {
            VStack {
                if let color {
                    if let colorName {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.white, lineWidth: 5)
                                .frame(width: 100, height: 100)
         
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(color))
                                .frame(width: 100, height: 100)
                        }

                            
                            
                            
                        Text(colorName)
                            .font(.headline)
                            .foregroundColor(.white)
                            .onChange(of: color) { name in
                                let rgbColor = color.calculateClosestColor()
                                self.colorName = rgbColor?.English ?? "Unknown Color"
                            }
                    }
                }
            }
            
            VStack {
                ColorSliderView(colorValue: $red, color: $color, containerCotentWidth: containerCotentWidth, iconColor: Color(.red))
                ColorSliderView(colorValue: $green, color: $color, containerCotentWidth: containerCotentWidth, iconColor: Color(.green))
                ColorSliderView(colorValue: $blue, color: $color, containerCotentWidth: containerCotentWidth, iconColor: Color(.blue))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topLeading) {
            Button(action: { }) {
                Text("Save")
                    .font(.headline)
            }
            .padding([.horizontal])
        }
        .overlay(alignment: .topTrailing) {
            Button(action: toggleSheet){
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(.white)
            }
            .padding([.horizontal])
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct ColorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetailView(color: .orange, colorName: "Orange", containerCotentWidth: 393, showColorDetail: .constant(true))
    }
}
