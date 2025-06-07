//
//  PopularMoviesResponse.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
import Foundation


struct MoviesModel: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int?
    let total_results: Int?
}
struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let vote_average: Double
    let release_date: String
    let backdrop_path: String?

    // Computed property for image URL (adjust base URL as needed)
    var backdropURL: URL? {
        guard let path = backdrop_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }
}


