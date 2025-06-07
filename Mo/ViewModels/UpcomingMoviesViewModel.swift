//
//  UpcomingMoviesViewModel.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
import Foundation

@MainActor
class UpcomingMoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?

    // Your fallback JSON string here
    private let fallbackJSON = """
    {
      "dates": { "maximum": "2025-05-07", "minimum": "2025-04-16" },
      "page": 1,
      "results": [
        {
          "adult": false,
          "backdrop_path": "/op3qmNhvwEvyT7UFyPbIfQmKriB.jpg",
          "genre_ids": [14, 12, 28],
          "id": 324544,
          "original_language": "en",
          "original_title": "In the Lost Lands",
          "overview": "A queen sends the powerful and feared sorceress Gray Alys to the ghostly wilderness of the Lost Lands in search of a magical power, where the sorceress and her guide, the drifter Boyce must outwit and outfight man and demon.",
          "popularity": 837.1695,
          "poster_path": "/iHf6bXPghWB6gT8kFkL1zo00x6X.jpg",
          "release_date": "2025-02-27",
          "title": "In the Lost Lands",
          "video": false,
          "vote_average": 6.364,
          "vote_count": 147
        },
        {
          "adult": false,
          "backdrop_path": "/2Nti3gYAX513wvhp8IiLL6ZDyOm.jpg",
          "genre_ids": [10751, 35, 12, 14],
          "id": 950387,
          "original_language": "en",
          "original_title": "A Minecraft Movie",
          "overview": "Four misfits find themselves struggling with ordinary problems when they are suddenly pulled through a mysterious portal into the Overworld: a bizarre, cubic wonderland that thrives on imagination. To get back home, they'll have to master this world while embarking on a magical quest with an unexpected, expert crafter, Steve.",
          "popularity": 695.7057,
          "poster_path": "/yFHHfHcUgGAxziP1C3lLt0q2T4s.jpg",
          "release_date": "2025-03-31",
          "title": "A Minecraft Movie",
          "video": false,
          "vote_average": 6.077,
          "vote_count": 523
        }
      ],
      "total_pages": 68,
      "total_results": 1357
    }
    """

    func fetchUpcomingMovies() async {
        guard
            let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming"),
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
            self.errorMessage = nil
        } catch {
            // Use fallback JSON on failure
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

