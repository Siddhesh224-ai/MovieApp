//
//  PopularMoviesView.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//
import SwiftUI
struct PopularMoviesView: View {
    @StateObject private var viewModel = PopularMoviesViewModel()

    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.movies) { movie in
                        WrapperView(movie: movie,cat: "Popular")
                    }
                }
                .padding()
            }
            .onAppear {
                Task {
                    await viewModel.fetchPopularMovies()
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil })
            ) {
                Alert(title: Text("Notice"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}


#Preview {
    PopularMoviesView()
}

