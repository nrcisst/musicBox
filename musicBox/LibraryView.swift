//
//  LibraryView.swift
//  miniAudible
//
//  Created by Biniam Habte on 5/1/25.
//
import SwiftUI
import Kingfisher
import Foundation

struct LibraryView: View {
    @EnvironmentObject var viewModel: BookViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.01, green: 0.02, blue: 0.05),
                    Color(red: 0.1, green: 0.1, blue: 0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            List {
                // 1️⃣ Put the header in its own Section (or as a List header)
                Text("Library")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .monospaced()
                    .padding(.vertical, 20)
                    .listRowBackground(Color.clear)
                
                    // 2️⃣ Now each book is its own row
                    ForEach(viewModel.books) { book in
                        NavigationLink {
                            DetailedView(book: book)
                        } label: {
                            HStack(spacing: 16) {
                                KFImage(book.coverURL)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                    Text(book.artist)
                                }
                                .foregroundColor(.white)
                                .monospaced()
                            }
                            .padding(.vertical, 8)
                        }
                    }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
    }
}


#Preview {
    LibraryView()
        .environmentObject(BookViewModel())
        .preferredColorScheme(.dark)
}
