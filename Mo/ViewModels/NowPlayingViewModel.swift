//
//  NowPlayingViewModel.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
import Foundation
import SwiftUI

class NowPlayingMoviesViewModel: ObservableObject {
    @Published var nowPlayingMovies: [Movie] = []
    @Published var errorMessage: String?

    private let apiKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MTcwM2VmMTAyMjRlMGVkYjYzNDRmZmQyMmFmZDI1YiIsIm5iZiI6MTc0OTI3MzU4My42NjEsInN1YiI6IjY4NDNjYmVmNWNhOTVhZTcxNjMwMGY1MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.F7RTFAoB6zo0Tr-BPKcLbDEkG8GYaHS6oQRIjL3-3Lk"

    private let fallbackJSON = """
    {
      "dates": {
        "maximum": "2025-04-16",
        "minimum": "2025-03-05"
      },
      "page": 1,
      "results": [
        {
          "adult": false,
          "backdrop_path": "/2Nti3gYAX513wvhp8IiLL6ZDyOm.jpg",
          "genre_ids": [10751, 35, 12, 14],
          "id": 950387,
          "original_language": "en",
          "original_title": "A Minecraft Movie",
          "overview": "Four misfits find themselves struggling with ordinary problems when they are suddenly pulled through a mysterious portal into the Overworld: a bizarre, cubic wonderland that thrives on imagination. To get back home, they'll have to master this world while embarking on a magical quest with an unexpected, expert crafter, Steve.",
          "popularity": 824.7134,
          "poster_path": "/iPPTGh2OXuIv6d7cwuoPkw8govp.jpg",
          "release_date": "2025-03-31",
          "title": "A Minecraft Movie",
          "video": false,
          "vote_average": 6.1,
          "vote_count": 482
        },
        {
          "adult": false,
          "backdrop_path": "/op3qmNhvwEvyT7UFyPbIfQmKriB.jpg",
          "genre_ids": [14, 12, 28],
          "id": 324544,
          "original_language": "en",
          "original_title": "In the Lost Lands",
          "overview": "A queen sends the powerful and feared sorceress Gray Alys to the ghostly wilderness of the Lost Lands in search of a magical power, where the sorceress and her guide, the drifter Boyce must outwit and outfight man and demon.",
          "popularity": 873.5678,
          "poster_path": "/iHf6bXPghWB6gT8kFkL1zo00x6X.jpg",
          "release_date": "2025-02-27",
          "title": "In the Lost Lands",
          "video": false,
          "vote_average": 5.926,
          "vote_count": 101
        }
      ]
    }
    """

    func fetchNowPlayingMovies() {
        Task {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing"),
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid URL"
                }
                return
            }

            components.queryItems = [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1")
            ]

            guard let finalURL = components.url else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid final URL"
                }
                return
            }

            var request = URLRequest(url: finalURL)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "Authorization": apiKey
            ]

            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoded = try JSONDecoder().decode(MoviesModel.self, from: data)

                DispatchQueue.main.async {
                    self.nowPlayingMovies = decoded.results
                }
            } catch {
                if let fallbackData = fallbackJSON.data(using: .utf8),
                   let fallbackResponse = try? JSONDecoder().decode(MoviesModel.self, from: fallbackData) {
                    DispatchQueue.main.async {
                        self.nowPlayingMovies = fallbackResponse.results
                        self.errorMessage = "Showing fallback data due to network error."
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to load movies and fallback data."
                    }
                }
            }
        }
    }
}
