//
//  ReferenceView.swift
//  InstColor
//
//  Created by Lei Cao on 12/3/22.
//

import SwiftUI

struct ReferenceColor: Identifiable {
    let id = UUID()
    let Color: String
    let BaseColor: String
    let BaseColorHex: String
    let Red: Int
    let Green: Int
    let Blue: Int
    let distance: CGFloat
    var children: [ReferenceColor]?
}

struct ReferenceRowView: View {
    var mapItem: RGBColor
    var containerCotentWidth = 0.0

    var body: some View {
        VStack {
            BorderedRectView(color: Color(UIColor(red: mapItem.Red, green: mapItem.Green, blue: mapItem.Blue)), cornerRadius: 15, lineWidth: 2, height: 50)
            Text(mapItem.Color)
                .font(.footnote)
                .lineLimit(1, reservesSpace: false)
        }
    }
}

struct ReferencesView: View {
    var containerCotentWidth = 0.0
    
    init(containerCotentWidth: Double = 0.0) {
        self.containerCotentWidth = containerCotentWidth
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func comparer(item1: ReferenceColor, item2: ReferenceColor) -> Bool {
        return item1.distance < item2.distance
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                let groupedColors = Dictionary(grouping: Settings.shared.colorMap, by: { $0.BaseColor } )
                let colors = groupedColors.map({ section -> ReferenceColor in
                    let baseColor = section.value[0]
                    let rgb = UIColor(hex: section.value[0].BaseColorHex)?.components
                    
                    let red = (rgb?.red ?? 0) * 255
                    let green = (rgb?.green ?? 0) * 255
                    let blue = (rgb?.blue ?? 0) * 255
                    
                    return ReferenceColor(Color: section.key, BaseColor: baseColor.BaseColor, BaseColorHex: baseColor.BaseColorHex, Red: Int(red), Green: Int(green), Blue: Int(blue), distance: calculate3dDistance(point1: (x: 0, y: 0, z: 0), point2: (x: red, y: green, z: blue)), children: section.value.map({ item in
                        ReferenceColor(Color: item.Color, BaseColor: item.BaseColor, BaseColorHex: item.BaseColorHex, Red: item.Red, Green: item.Green, Blue: item.Blue, distance: calculate3dDistance(point1: (x: red, y: green, z: blue), point2: (x: Double(item.Red), y: Double(item.Green), z: Double(item.Blue))))
                    }).sorted(by: comparer))
                }).sorted(by: comparer)
                
                List {
                    OutlineGroup(colors, children: \.children) { child in
                        NavigationLink(destination: ColorDetailView(color: UIColor(red: child.Red, green: child.Green, blue: child.Blue), showModalButtons: false, selectedDetent: .large)) {
                            VStack {
                                ReferenceRowView(mapItem: RGBColor(Color: child.Color, BaseColor: child.BaseColor, BaseColorHex: child.BaseColorHex, Red: child.Red, Green: child.Green, Blue: child.Blue))
                            }
                        }
                    }
                    .listRowBackground(Color.black)
                }
                .modifier(SimpleModalViewModifier())
                .navigationTitle("References")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
                .background(.black)
            }
        }
    }
}

struct ReferenceView_Previews: PreviewProvider {
    static var previews: some View {
        ReferencesView(containerCotentWidth: 100)
    }
}
