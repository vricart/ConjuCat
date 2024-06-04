//
//  LanguagePicker.swift
//  ConjuCat
//
//  Created by Marc Vicky Ricart on 10.06.2024.
//

import SwiftUI

struct LanguagePicker: View {
    @Binding var selectedIndex: Int
        let items: [String]

        var body: some View {
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    Button(action: {
                        selectedIndex = index
                    }) {
                        Text(items[index].uppercased())
                            .font(.customFont(font: .montserrat, style: .medium, size: .caption))
                            .foregroundColor(selectedIndex == index ? .black : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 32)
                            .background(selectedIndex == index ? Color.white : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .background(Color.secondaryRedColor.opacity(0.25))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondaryRedColor.opacity(0.25), lineWidth: 2)
            )
        }
}

#Preview {
    LanguagePicker(selectedIndex: .constant(0), items: ["Catalan", "Spanish"])
}
