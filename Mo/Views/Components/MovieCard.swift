//
//  MovieCard.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
import SwiftUI
struct MovieCard: View {
    let movie: Movie
    let category: String
    var screenWidth: CGFloat

    @AppStorage("myList") private var myListData: Data = Data()
    @State private var isInMyList: Bool = false

    var body: some View {
        let cardWidth = screenWidth * 0.8
        let cardHeight = cardWidth * 9 / 16

        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: movie.movieImage) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.3)
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Color.red.opacity(0.3)
                @unknown default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: cardWidth, height: cardHeight)
            .clipped()

            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(width: cardWidth, height: cardHeight)

            VStack(alignment: .leading, spacing: 6) {
                Text(category)
                    .font(.caption).bold()
                    .padding(6)
                    .background(Color.purple.opacity(0.8))
                    .clipShape(Capsule())

                Text(movie.title)
                    .font(.title2).bold()
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(movie.overview)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(2)

                HStack(spacing: 12) {
                    Label(String(format: "%.1f", movie.vote_average), systemImage: "star.fill")
                        .foregroundColor(.yellow)
                    Text(movie.release_date)
                        .foregroundColor(.white.opacity(0.85))
                }
                .font(.caption)

                HStack {
                    Button {
                        toggleMyList()
                    } label: {
                        Label(isInMyList ? "In List" : "My List",
                              systemImage: isInMyList ? "checkmark" : "plus")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(isInMyList ? Color.green : Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .frame(width: cardWidth, height: cardHeight)
        .cornerRadius(16)
        .shadow(radius: 8)
        .onAppear {
            loadMyListStatus()
        }
    }

    private func loadMyListStatus() {
        let currentList = (try? JSONDecoder().decode([Movie].self, from: myListData)) ?? []
        isInMyList = currentList.contains(where: { $0.id == movie.id })
    }

    private func toggleMyList() {
        var currentList = (try? JSONDecoder().decode([Movie].self, from: myListData)) ?? []

        if let index = currentList.firstIndex(where: { $0.id == movie.id }) {
            currentList.remove(at: index)
            isInMyList = false
        } else {
            currentList.append(movie)
            isInMyList = true
        }

        if let encoded = try? JSONEncoder().encode(currentList) {
            myListData = encoded
        }
    }
}



