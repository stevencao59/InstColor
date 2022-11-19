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

    @State var hexText: String
    
    var color: UIColor
    var containerCotentWidth: Double
    
    init(color: UIColor, containerCotentWidth: Double, showColorDetail: Binding<Bool>) {
        self.color = color
        self.hexText = color.toHexString() ?? "Unknown Hex"
        self.containerCotentWidth = containerCotentWidth
        self._showColorDetail = showColorDetail
    }
    
    func toggleSheet() {
        showColorDetail.toggle()
    }
    
    var body: some View {
        VStack {
            ColorIconView(color: model.color, colorName: model.colorName)
            
            SliderGroupContainerView(model: model, containerCotentWidth: containerCotentWidth)
            
            ColorHexTextView(displayColor: $model.color)

            ColorTypeView(complementaryColor: model.complementaryColor, triadicColor: model.triadicColor, splitComplementaryColor: model.splitComplementaryColor, analogousColor: model.analogousColor, tetradicColor: model.tetradicColor,  monochromaticColor: model.monochromaticColor, referenceColor: $model.color)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topLeading) {
            Button(action: { }) {
                Text("Save")
                    .font(.headline)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: toggleSheet){
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(.white)
            }
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
