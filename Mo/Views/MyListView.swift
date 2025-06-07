//
//  MyListView.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//

import SwiftUI

struct MyListView: View {
    @AppStorage("myList") private var myListData: Data = Data()
    @State private var savedMovies: [Movie] = []

    var body: some View {
        NavigationStack {
            if savedMovies.isEmpty {
                Text("Your list is empty.")
                    .foregroundColor(.gray)
                    .navigationTitle("My List")
            } else {
                List(savedMovies) { movie in
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text(movie.release_date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(movie.overview)
                            .font(.caption)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }
                .background(Color.black.ignoresSafeArea())
                .navigationTitle("My List")
            }
        }
        .onAppear {
            loadMyList()
        }
    }

    func loadMyList() {
        if let decoded = try? JSONDecoder().decode([Movie].self, from: myListData) {
            savedMovies = decoded
        } else {
            savedMovies = []
        }
    }
}
