//
//  ColorResultView.swift
//  InstColor
//
//  Created by Lei Cao on 10/6/22.
//

import SwiftUI

struct ColorResultView: View {
    @ObservedObject var model: ColorResultViewModel
    
    init(model: ColorResultViewModel) {
        self.model = model
    }
    
    func clickToShowSheet() {
        model.showColorDetail.toggle()
    }
    
    var body: some View {
        Button(action: clickToShowSheet) {
            HStack {
                if let color = model.color {
                    BorderedRectView(color: Color(color), cornerRadius: defaultItemSize, lineWidth: 1, width: defaultItemSize, height: defaultItemSize)
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
        }
        
        .sheet(isPresented: $model.showColorDetail) {
            if let color = model.color {
                ColorDetailView(color: color, showModalButtons: true, selectedDetent: model.selectedDentent, saveHistory: true)
                    .presentationDetents([.medium, .large], selection: $model.selectedDentent)
            }
        }
    }
}

struct ColorResultView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            ColorResultView(model: ColorResultViewModel(camera: ContentViewModel().cameraManager))
        }
        .ignoresSafeArea()
    }
}
