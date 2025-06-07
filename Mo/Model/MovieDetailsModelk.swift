//
//  MovieDetail.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
import Foundation

struct MovieDetailsModelk: Decodable {
    let title: String
    let overview: String
    let release_date: String
    let vote_average: Double
    let poster_path: String?
    let genres: [Genre]

    struct Genre: Decodable {
        let name: String
    }
}
