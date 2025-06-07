//
//  MovieDetailViewModel.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
import Foundation

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movie: MovieDetailsModelk?

    func fetchMovieDetail(movieId: Int) async {
        guard var components = URLComponents(string: "https://api.themoviedb.org/3/movie/\(movieId)") else { return }
        components.queryItems = [URLQueryItem(name: "language", value: "en-US")]

        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MTcwM2VmMTAyMjRlMGVkYjYzNDRmZmQyMmFmZDI1YiIsIm5iZiI6MTc0OTI3MzU4My42NjEsInN1YiI6IjY4NDNjYmVmNWNhOTVhZTcxNjMwMGY1MSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.F7RTFAoB6zo0Tr-BPKcLbDEkG8GYaHS6oQRIjL3-3Lk"
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(MovieDetailsModelk.self, from: data)
            self.movie = decoded
        } catch {
            print("Failed to fetch movie detail:", error)
        }
    }
}

