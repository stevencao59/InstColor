//
//  ColorHexTextView.swift
//  InstColor
//
//  Created by Lei Cao on 11/14/22.
//

import SwiftUI

struct ColorHexTextView: View {
    @Binding var displayColor: UIColor
    @State var hexText: String = ""

    var keyboardFocusState: FocusState<FocusElement?>.Binding

    var body: some View {
        HStack {
            Text("HEX: #")
                .font(.body)
                .bold()
            TextField("", text: $hexText)
                .focused(keyboardFocusState, equals: .hex)
                .scrollContentBackground(.hidden)
                .background(Color(UIColor(red: 66, green: 66, blue: 66)))
                .multilineTextAlignment(.center)
                .cornerRadius(5)
                .frame(width: 100, height: 40)
                .onSubmit {
                    if let color = UIColor(hex: hexText) {
                        displayColor = color
                    }
                }
                .onChange(of: displayColor) { color in
                    if let text = color.toHexString() {
                        hexText = text
                    }
                }
        }
        .foregroundColor(.white)
        .padding([.horizontal])
    }
}

struct ColorHexTextView_Previews: PreviewProvider {
    static var focused: FocusState<FocusElement?> = FocusState<FocusElement?>()
    static var previews: some View {
        ColorHexTextView(displayColor: .constant(.white), keyboardFocusState: focused.projectedValue)
    }
}
