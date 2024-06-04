//
//  MainView.swift
//  ConjuCat
//
//  Created by Marc Vicky Ricart on 07.06.2024.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = Tab.home
    @State private var homeNavigationPath = NavigationPath()
    @State private var searchText = ""

    enum Tab: Hashable {
        case home
        case search
        case profile
    }

    var body: some View {
            TabView(selection: tabSelection()) {
                Group {
                    NavigationStack(path: $homeNavigationPath) {
                        ContentView(navigationPath: $homeNavigationPath, searchText: $searchText)
                            .toolbarBackground(.white, for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(Tab.home)

                    // Uncomment and update the following to add additional tabs
                    /*
                    NavigationStack {
                        SearchView()
                            .navigationTitle("Search")
                            .toolbarBackground(.white, for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
                    }
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(Tab.search)

                    NavigationStack {
                        ProfileView()
                            .navigationTitle("Profile")
                            .toolbarBackground(.white, for: .navigationBar)
                            .toolbarBackground(.visible, for: .navigationBar)
                    }
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(Tab.profile)
                    */
                }
                .toolbarBackground(.white, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.light, for: .tabBar)
            }
            .onChange(of: selectedTab) { newValue, _ in
                if newValue == .home {
                    homeNavigationPath = NavigationPath()
                    searchText = ""
                }
            }
        }
    
    
    private func tabSelection() -> Binding<Tab> {
        Binding {
            self.selectedTab
        } set: { tappedTab in
            if tappedTab == self.selectedTab {
                // User tapped on the currently active tab icon => Pop to root/Scroll to top
                if homeNavigationPath.isEmpty {
                    // User already on home view, no action needed
                } else {
                    // Pop to root view by clearing the stack
                    homeNavigationPath = NavigationPath()
                    searchText = ""
                }
            }
            // Set the current tab to the user selected tab
            self.selectedTab = tappedTab
        }
    }
}

#Preview {
    MainView()
}
