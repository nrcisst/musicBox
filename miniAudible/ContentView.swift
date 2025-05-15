//
//  ContentView.swift
//  miniAudible
//
//  Created by Biniam Habte on 5/1/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: BookViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                    Color(red: 0.01, green: 0.02, blue: 0.05),
                    Color(red: 0.1, green: 0.1, blue: 0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 50) {
                        Text("MusicBox")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .monospaced()

                        
                        NavigationLink{
                            LibraryView()
                        } label: {
                            ZStack {
                                Image("library")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 120)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.indigo, lineWidth: 0.75)
                                    )
                                
                                Text("Library")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .bold()
                                    .background(Color.black.opacity(0.2))
                                    .clipShape(Capsule())
                                    .monospaced()
                            }
                            .padding(.top, 30)
                        }
                        
                        NavigationLink{
                            SearchView()
                        } label: {
                            ZStack {
                                Image("search2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 120)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.indigo, lineWidth: 0.75)
                                    )
                                
                                Text("Search")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .bold()
                                    .background(Color.black.opacity(0))
                                    .clipShape(Capsule())
                                    .monospaced()
                            }
                        }
                        .padding(.top, 10)
                    }
                   /* .task{
                        await viewModel.fetchBook(matching: "Carti")
                    } */
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BookViewModel())
}
