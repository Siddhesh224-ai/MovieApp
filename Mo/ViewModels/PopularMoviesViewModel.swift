//
//  PopularMoviesViewModel.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
import Foundation

@MainActor
class PopularMoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?

    private let fallbackJSON = """
    {
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
          "popularity": 789.8905,
          "poster_path": "/iHf6bXPghWB6gT8kFkL1zo00x6X.jpg",
          "release_date": "2025-02-27",
          "title": "In the Lost Lands",
          "video": false,
          "vote_average": 6.388,
          "vote_count": 156
        },
        {
          "adult": false,
          "backdrop_path": "/k32XKMjmXMGeydykD32jfER3BVI.jpg",
          "genre_ids": [28, 9648, 18],
          "id": 1045938,
          "original_language": "en",
          "original_title": "G20",
          "overview": "After the G20 Summit is overtaken by terrorists, President Danielle Sutton must bring all her statecraft and military experience to defend her family and her fellow leaders.",
          "popularity": 687.7088,
          "poster_path": "/tSee9gbGLfqwvjoWoCQgRZ4Sfky.jpg",
          "release_date": "2025-04-09",
          "title": "G20",
          "video": false,
          "vote_average": 6.449,
          "vote_count": 186
        }
      ],
      "total_pages": 49754,
      "total_results": 995075
    }
    """

    func fetchPopularMovies() async {
        guard
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular"),
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
            if let fallbackData = fallbackJSON.data(using: .utf8),
               let fallbackResponse = try? JSONDecoder().decode(MoviesModel.self, from: fallbackData) {
                self.movies = fallbackResponse.results
                self.errorMessage = "Failed to fetch from network. Showing fallback data."
            } else {
                self.errorMessage = "Failed to load movies."
            }
        }
    }
}
