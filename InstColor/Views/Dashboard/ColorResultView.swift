//
//  ColorResultView.swift
//  InstColor
//
//  Created by Lei Cao on 10/6/22.
//

import SwiftUI

struct ColorResultView: View {
    @ObservedObject var model: ColorResultViewModel

    let color: UIColor
    
    let resultSize: CGFloat = UIScreen.screenHeight / defaultScreenHeight * 40
    
    init(model: ColorResultViewModel, color: UIColor) {
        self.model = model
        self.color = color
    }
    
    func clickToShowSheet() {
        model.showColorDetail.toggle()
    }
    
    var body: some View {
        Button(action: clickToShowSheet) {
            HStack {
                BorderedRectView(color: Color(color), cornerRadius: resultSize, lineWidth: 1, width: resultSize, height: resultSize)
                    .onChange(of: color) { newValue in
                        model.color = newValue
                    }
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(model.colorName)")
                            .lineLimit(1)
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }

            }
        }
        
        .sheet(isPresented: $model.showColorDetail) {
            ColorDetailView(color: color, showModalButtons: true, selectedDetent: model.selectedDentent)
                .presentationDetents([.medium, .large], selection: $model.selectedDentent)
        }
    }
}

struct ColorResultView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            ColorResultView(model: ColorResultViewModel(camera: ContentViewModel().cameraManager), color: UIColor(.red))
        }
        .ignoresSafeArea()
    }
}
