//
//  SegmentedPickerView.swift
//  InstColor
//
//  Created by Lei Cao on 1/29/23.
//

import SwiftUI

struct SegmentedPickerView: View {
    @Binding var preselectedIndex: Int
    var options: [String]

    let color = Color.white
    let frameHeight: CGFloat = UIScreen.screenHeight / defaultScreenHeight * 30
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                let isSelected = preselectedIndex == index
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.1))
                    Rectangle()
                        .fill(color)
                        .cornerRadius(5)
                        .opacity(isSelected ? 0.8 : 0.01)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.2,
                                                             dampingFraction: 2,
                                                             blendDuration: 0.5)) {
                                preselectedIndex = index
                            }
                        }
                }
                .overlay(
                    Text(options[index])
                        .foregroundColor(isSelected ? .black : .white)
                        .font(.footnote)
                        .bold()
                )
            }
        }
        .cornerRadius(5)
        .frame(height: frameHeight)
    }
}

struct SegmentedPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedPickerView(preselectedIndex: .constant(0), options: ["Test1", "Test2", "Test3"])
    }
}
