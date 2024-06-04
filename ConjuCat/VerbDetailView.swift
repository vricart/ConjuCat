//
//  VerbDetailView.swift
//  ConjuCat
//
//  Created by Marc Vicky Ricart on 05.06.2024.
//

import SwiftUI
import Combine

class Debouncer: ObservableObject {
    private var cancellable: AnyCancellable?
    private let delay: RunLoop.SchedulerTimeType.Stride
    
    init(delay: RunLoop.SchedulerTimeType.Stride) {
        self.delay = delay
    }
    
    func callAsFunction(action: @escaping () -> Void) {
        cancellable?.cancel()
        cancellable = Just(())
            .delay(for: delay, scheduler: RunLoop.main)
            .sink(receiveValue: { _ in action() })
    }
}

struct VerbDetailView: View {
    @State private var searchText = ""
    @State private var selectedVerb: String
    @State private var selectedLanguage: String
    @State private var verbDetails: VerbDetails? = nil
    @State private var isLoading = true
    @Binding var navigationPath: NavigationPath
    @StateObject private var debouncer = Debouncer(delay: 0.5)
    @State private var isSearching = false
    
    let languages = ["Catalan", "Spanish"]
    
    init(verb: String, language: String, navigationPath: Binding<NavigationPath>) {
        _selectedVerb = State(initialValue: verb.lowercased())
        _selectedLanguage = State(initialValue: language)
        _navigationPath = navigationPath
    }
    
    var filteredVerbs: [String] {
        DatabaseManager.shared.fetchVerbs(in: selectedLanguage).filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ZStack {
            Color.primaryYellowColor.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                CustomSearchBar(text: $searchText)
                    .onChange(of: searchText) { oldValue, newValue in
                        isSearching = !newValue.isEmpty
                        if !newValue.isEmpty {
                            debouncer {
                                isLoading = true
                                if let matchingVerb = filteredVerbs.first(where: { $0.lowercased() == newValue.lowercased() }) {
                                    selectedVerb = matchingVerb.lowercased()
                                    loadVerbDetails()
                                } else {
                                    isLoading = false
                                }
                            }
                        } else {
                            isSearching = false
                        }
                    }
                    .padding(.horizontal)
                
                Picker("Language", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language.lowercased())
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: selectedLanguage) { oldLanguage, newLanguage in
                    switchLanguage(oldLanguage: oldLanguage, newLanguage: newLanguage)
                }
                .padding(.bottom)
                
                if isSearching {
                    VStack {
                        List {
                            ForEach(filteredVerbs, id: \.self) { verb in
                                Button(action: {
                                    selectedVerb = verb.lowercased()
                                    searchText = ""
                                    isSearching = false
                                    hideKeyboard()
                                    loadVerbDetails()
                                }) {
                                    Text(verb)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 10)
                    .padding()
                    
                } else {
                    ScrollView {
                        if isLoading {
                            Text("Loading...")
                                .onAppear {
                                    loadVerbDetails()
                                }
                        } else if let details = verbDetails {
                            
                            // Section 1: Title and Translation
                            VStack(alignment: .leading) {
                                Text(details.verb.capitalized)
                                    .font(.customFont(font: .montserrat, style: .bold, size: .largeTitle))
                                    .padding(.bottom, 1)
                                
                                Text(details.translation)
                                    .font(.customFont(font: .montserrat, style: .medium, size: .title))
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                
                                // Section 2: Gerund and Participle
                                Section {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Gerund")
                                                .font(.customFont(font: .montserrat, style: .bold, size: .body))
                                                .foregroundColor(.greyColor)
                                                .padding(.vertical, 8)
                                            
                                            Text("Participle")
                                                .font(.customFont(font: .montserrat, style: .bold, size: .body))
                                                .foregroundColor(.greyColor)
                                        }
                                        .padding(.trailing, 24)
                                        
                                        VStack(alignment: .leading) {
                                            Text(details.gerund)
                                                .font(.customFont(font: .montserrat, style: .medium, size: .body))
                                                .padding(.vertical, 8)
                                            Text(details.participle)
                                                .font(.customFont(font: .montserrat, style: .medium, size: .body))
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top)
                                .padding(.bottom, 10)
                                
                                // Section 3: Indicative Tenses
                                Section {
                                    VStack(alignment: .leading) {
                                        Text("INDICATIVE")
                                            .font(.customFont(font: .montserrat, style: .bold, size: .title3))
                                            .padding(.bottom, 10)
                                        
                                        // Present Tense
                                        TenseView(title: "Present", conjugations: details.indicativePresent, language: selectedLanguage)
                                        // Preterite Tense
                                        TenseView(title: "Preterite", conjugations: details.indicativePreterite, language: selectedLanguage)
                                        // Imperfect Tense
                                        TenseView(title: "Imperfect", conjugations: details.indicativeImperfect, language: selectedLanguage)
                                        // Future Tense
                                        TenseView(title: "Future", conjugations: details.indicativeFuture, language: selectedLanguage)
                                        // Conditional Tense
                                        TenseView(title: "Conditional", conjugations: details.indicativeConditional, language: selectedLanguage)
                                    }
                                }
                                .padding()
                                
                                // Section 4: Subjunctive Tenses
                                Section {
                                    VStack(alignment: .leading) {
                                        Text("SUBJUNCTIVE")
                                            .font(.customFont(font: .montserrat, style: .bold, size: .title3))
                                            .padding(.bottom, 10)
                                        
                                        // Present Tense
                                        TenseView(title: "Present", conjugations: details.subjunctivePresent, language: selectedLanguage)
                                        // Imperfect Tense
                                        TenseView(title: "Imperfect", conjugations: details.subjunctiveImperfect, language: selectedLanguage)
                                        // Future Tense
                                        TenseView(title: "Future", conjugations: details.subjunctiveFuture, language: selectedLanguage)
                                    }
                                }
                                .padding()
                                
                                // Section 5: Imperative
                                Section {
                                    VStack(alignment: .leading) {
                                        Text("IMPERATIVE")
                                            .font(.customFont(font: .montserrat, style: .bold, size: .title3))
                                            .padding(.bottom, 10)
                                        
                                        TenseView(title: "Affirmative", conjugations: details.imperative, language: selectedLanguage)
                                    }
                                }
                                .padding()
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            loadVerbDetails()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func loadVerbDetails() {
        isLoading = true
        verbDetails = nil
        DispatchQueue.main.async {
            verbDetails = DatabaseManager.shared.fetchVerbDetails(for: selectedVerb, in: selectedLanguage)
            isLoading = false
        }
    }
    
    private func switchLanguage(oldLanguage: String, newLanguage: String) {
        if let matchingVerb = DatabaseManager.shared.fetchMatchingVerb(for: selectedVerb.lowercased(), fromLanguage: oldLanguage, toLanguage: newLanguage) {
            selectedVerb = matchingVerb
            loadVerbDetails()
        } else {
            loadVerbDetails()
        }
    }
}

#Preview {
    VerbDetailView(verb: "ser", language: "Spanish", navigationPath: .constant(NavigationPath()))
}

