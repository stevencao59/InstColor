//
//  CloseButtonView.swift
//  InstColor
//
//  Created by Lei Cao on 12/24/22.
//

import SwiftUI

struct CloseButtonView: View {
    @Environment(\.dismiss) private var dismiss
    
    func dismissView() {
        dismiss()
    }
    
    var body: some View {
        Button(action: dismissView) {
            Text("Close")
                .foregroundColor(.blue)
        }
    }
}

struct CloseButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CloseButtonView()
    }
}
