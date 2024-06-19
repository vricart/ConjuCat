//
//  ContentView.swift
//  ConjuCat
//
//  Created by Marc Vicky Ricart on 04.06.2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var navigationPath: NavigationPath
    @Binding var searchText: String
    @State private var selectedLanguage = "Catalan"
    let languages = ["Catalan", "Spanish"]

    var filteredVerbs: [String] {
        DatabaseManager.shared.fetchVerbs(in: selectedLanguage).filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ZStack {
            Color.primaryYellowColor.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack {
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    CustomSearchBar(text: $searchText)
                        .padding()

                    if !searchText.isEmpty {
                        List {
                            ForEach(filteredVerbs, id: \.self) { verb in
                                Button(action: {
                                    navigationPath.append(VerbNavigationData(verb: verb, language: selectedLanguage))
                                }) {
                                    Text(verb.capitalized)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .frame(maxHeight: 150)
                        .padding(.horizontal)
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 10)
                .padding()

                Spacer()
            }
        }
        .navigationTitle("ConjuCat")
        .navigationDestination(for: VerbNavigationData.self) { data in
            VerbDetailView(verb: data.verb, language: data.language, navigationPath: $navigationPath)
        }
    }
}

#Preview {
    ContentView(navigationPath: .constant(NavigationPath()), searchText: .constant(""))
}
