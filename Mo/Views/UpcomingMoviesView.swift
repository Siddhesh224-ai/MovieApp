//
//  UpcomingMoviesView.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
import SwiftUI
struct UpcomingMoviesView: View {
    @StateObject private var vm = UpcomingMoviesViewModel()

        var body: some View {
            GeometryReader { geo in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(vm.movies) { movie in
                            WrapperView(movie: movie, cat: "Upcoming")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 40)
                }
                .task {
                    await vm.fetchUpcomingMovies()
                }
                .overlay(alignment: .top) {
                    if let error = vm.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .padding(.top, 20)
                    }
                }
            }
        }
    }
#Preview {
    UpcomingMoviesView()
}
