//
//  TenseView.swift
//  ConjuCat
//
//  Created by Marc Vicky Ricart on 07.06.2024.
//

import SwiftUI

struct TenseView: View {
    var title: String
    var conjugations: [String: String]
    var language: String

    private var personOrder: [String] {
        switch language {
        case "Spanish":
            return ["yo", "tú", "él/ella", "nosotros", "vosotros", "ellos/ellas"]
        case "Catalan":
            return ["jo", "tu", "ell/ella", "nosaltres", "vosaltres", "ells/elles"]
        default:
            return conjugations.keys.sorted()
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !title.isEmpty {
                
                HStack {    
                    Text(title)
                        .font(.customFont(font: .montserrat, style: .bold, size: .title3))
                }
                .padding(.bottom, 12)
            }
            
            ForEach(personOrder, id: \.self) { person in
                if let conjugation = conjugations[person] {
                    HStack {
                        
                        Text(person)
                            .font(.customFont(font: .montserrat, style: .bold, size: .body))
                            .foregroundColor(.greyColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Text(conjugation)
                            .font(.customFont(font: .montserrat, style: .medium, size: .body))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .padding(.bottom, 32)
    }
}

#Preview {
    TenseView(title: "Present", conjugations: ["yo": "soy", "tú": "eres", "él/ella": "es", "nosotros": "somos", "vosotros": "sois", "ellos/ellas": "son"], language: "Spanish")
}
