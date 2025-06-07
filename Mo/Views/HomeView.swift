//
//  ContentView.swift
//  Mo
//
//  Created by Siddhesh Mutha on 07/06/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // App Title
                    HStack {
                        Text("Movieflix")
                            .font(.largeTitle).bold()
                            .foregroundColor(.purple)
                            .padding(.top, 32)
                            .padding(.horizontal)
                    }

                    // Now Playing Section
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Now Playing")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        NowPlayingView()
                            .frame(height: 200)
                    }

                    // Popular Section
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Popular")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        PopularMoviesView()
                            .frame(height: 200)
                    }

                    // Top Rated Section
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Top Rated")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        TopRatedMoviesView()
                            .frame(height: 200)
                    }

                    // Upcoming Section
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Upcoming")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.top, 50)
                        UpcomingMoviesView()
                            .frame(height: 200)
                    }
                }
                .padding(.bottom)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}



#Preview {
    HomeView()
}
