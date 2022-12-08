//
//  TooltipView.swift
//  InstColor
//
//  Created by Lei Cao on 12/5/22.
//

import Foundation
import SwiftUI

struct TooltipView: View {
    @Environment(\.dismiss) private var dismiss
    var title: String?
    var tooltipsText: String?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { dismiss() }){
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(.white)
                }
                .padding([.top, .trailing])
            }
            ScrollView {
                Color.clear
                VStack(alignment: .leading) {
                    Text(title ?? "")
                        .font(.title)
                        .bold()
                        .padding([.vertical])
                    Text(tooltipsText ?? "")
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}
