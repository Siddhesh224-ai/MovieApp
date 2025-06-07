//
//  TopRatedMoviesViewModel.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
import SwiftUI
import Foundation



@MainActor
class TopRatedMoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?

    private let fallbackJSON = """
    {
      "page": 1,
      "results": [
        {
          "adult": false,
          "backdrop_path": "/zfbjgQE1uSd9wiPTX4VzsLi0rGG.jpg",
          "genre_ids": [18, 80],
          "id": 278,
          "original_language": "en",
          "original_title": "The Shawshank Redemption",
          "overview": "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
          "popularity": 45.3817,
          "poster_path": "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
          "release_date": "1994-09-23",
          "title": "The Shawshank Redemption",
          "video": false,
          "vote_average": 8.7,
          "vote_count": 28127
        },
        {
          "adult": false,
          "backdrop_path": "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg",
          "genre_ids": [18, 80],
          "id": 238,
          "original_language": "en",
          "original_title": "The Godfather",
          "overview": "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.",
          "popularity": 41.4734,
          "poster_path": "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
          "release_date": "1972-03-14",
          "title": "The Godfather",
          "video": false,
          "vote_average": 8.7,
          "vote_count": 21329
        }
      ]
    }
    """

    func fetchTopRatedMovies() async {
        guard
            let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated"),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            self.errorMessage = "Invalid URL"
            return
        }

        components.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]

        guard let finalURL = components.url else {
            self.errorMessage = "Invalid URL components"
            return
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MTcwM2VmMTAyMjRlMGVkYjYzNDRmZmQyMmFmZDI1YiIsIm5iZiI6MTc0OTI3MzU4My42NjEsInN1YiI6IjY4NDNjYmVmNWNhOTVhZTcxNjMwMGY1MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.F7RTFAoB6zo0Tr-BPKcLbDEkG8GYaHS6oQRIjL3-3Lk"
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(MoviesModel.self, from: data)
            self.movies = decodedResponse.results
        } catch {
            // Fallback JSON
            if let fallbackData = fallbackJSON.data(using: .utf8),
               let fallbackResponse = try? JSONDecoder().decode(MoviesModel.self, from: fallbackData) {
                self.movies = fallbackResponse.results
                self.errorMessage = "Failed to fetch network data. Showing fallback."
            } else {
                self.errorMessage = "Failed to load movies."
            }
        }
    }
}

