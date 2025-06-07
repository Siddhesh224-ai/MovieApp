//
//  DetailView.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//

import SwiftUI

struct DetailView: View {
    let movie: Movie
    @StateObject private var viewModel = MovieDetailViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                if let movieDetail = viewModel.movie {
                    VStack(alignment: .leading, spacing: 16) {
                        if let poster = movieDetail.poster_path {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(poster)")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(height: 400)
                            .clipped()
                        }

                        Text(movieDetail.title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.white)

                        Text("Release Date: \(movieDetail.release_date)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("Rating: \(String(format: "%.1f", movieDetail.vote_average))/10")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("Genres: \(movieDetail.genres.map { $0.name }.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text(movieDetail.overview)
                            .font(.body)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                } else {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle(movie.title) 
            .task {
                await viewModel.fetchMovieDetail(movieId: movie.id)
            }
           
        }
    }
}
