//
//  ColorDetailView.swift
//  InstColor
//
//  Created by Lei Cao on 11/5/22.
//

import SwiftUI

struct ColorDetailView: View {
    @StateObject var model = ColorDetailViewModel()
    
    @Binding var showColorDetail: Bool

    var color: UIColor
    var containerCotentWidth: Double
    
    init(color: UIColor, containerCotentWidth: Double, showColorDetail: Binding<Bool>) {
        self.color = color
        self.containerCotentWidth = containerCotentWidth
        self._showColorDetail = showColorDetail
    }
    
    func toggleSheet() {
        showColorDetail.toggle()
    }
    
    var body: some View {
        VStack {
            VStack {
                if let color = model.color {
                    if let colorName = model.colorName {
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
                    }
                }
            }
            
            VStack {
                ColorSliderView(colorValue: $model.red, colorValueText: $model.redText, color: $model.color, containerCotentWidth: containerCotentWidth, iconColor: Color(.red))
                ColorSliderView(colorValue: $model.green, colorValueText: $model.greenText, color: $model.color, containerCotentWidth: containerCotentWidth, iconColor: Color(.green))
                ColorSliderView(colorValue: $model.blue, colorValueText: $model.blueText, color: $model.color, containerCotentWidth: containerCotentWidth, iconColor: Color(.blue))
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
        .onAppear() {
            self.model.color = color
        }
    }
}

struct ColorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ColorDetailView(color: .orange, containerCotentWidth: 393, showColorDetail: .constant(true))
    }
}
