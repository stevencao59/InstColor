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
            ColorIconView(color: model.color, colorName: model.colorName)
            
            ColorSliderGroupView(red: $model.red, green: $model.green, blue: $model.blue, redText: $model.redText, greenText: $model.greenText, blueText: $model.blueText, color: $model.color, containerCotentWidth: containerCotentWidth)
            
            ColorTypeView(complementaryColor: model.complementaryColor, triadicColor: model.triadicColor, splitComplementaryColor: model.splitComplementaryColor, analogousColor: model.analogousColor, tetradicColor: model.tetradicColor,  monochromaticColor: model.monochromaticColor, referenceColor: $model.color)
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
