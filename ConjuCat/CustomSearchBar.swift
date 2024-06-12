//
//  CustomSearchBar.swift
//  ConjuCat
//
//  Created by Marc Vicky Ricart on 08.06.2024.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Buscar ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray).opacity(0.15))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    CustomSearchBar(text: .constant(""))
}
