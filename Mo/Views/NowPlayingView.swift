//
//  NowPlayingView.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//

import SwiftUI

struct NowPlayingView: View {
    @StateObject private var viewModel = NowPlayingMoviesViewModel()

    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.nowPlayingMovies) { movie in
                            WrapperView(movie: movie,cat: "Now Playing")
                        }
                    }
                    .padding()
                }
                .onAppear {
                    Task {
                        await viewModel.fetchNowPlayingMovies()
                    }
                }
                .alert(item: $viewModel.errorMessage) { msg in
                    Alert(title: Text("Error"), message: Text(msg), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}

struct WrapperView: View {
    let movie: Movie
    let cat: String
    var body: some View {
        NavigationLink(destination: DetailView(movie:movie)) {
            MovieCard(movie: movie, category: cat, screenWidth: UIScreen.main.bounds.width)
        }
    }
}

#Preview {
    NowPlayingView()
}
