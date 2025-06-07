//
//  ContentView.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
// ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "film")
            }

            NavigationView {
                MyListView()
            }
            .tabItem {
                Label("My List", systemImage: "bookmark")
            }
            
        }
    }
}

#Preview {
    ContentView()
}

