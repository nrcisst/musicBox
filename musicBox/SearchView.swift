//
//  SearchView.swift
//  miniAudible
//
//  Created by Biniam Habte on 5/12/25.
//
import SwiftUI
import Foundation
import Kingfisher

struct SearchView: View {
    @State var userQuery = ""
    @EnvironmentObject var viewModel: BookViewModel
    
    
    
    var filteredBooks: [Book]{
        if userQuery.isEmpty {
            return viewModel.searchResult
        }else {
            return viewModel.searchResult.filter{album in
                album.artist.localizedCaseInsensitiveContains(userQuery)
                
            }
        }
    }
    
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
                HStack {
                    TextField(
                        "Search albums",
                        text: $userQuery,
                        onCommit: {Task{await viewModel.fetchBook(matching: userQuery)}
                        })
                    .font(.system(size: 35, weight: .heavy, design: .monospaced))
                }
                .listRowBackground(Color.clear)
                
                ForEach(filteredBooks){book in
                    NavigationLink {
                        DetailedView(book: book)
                    } label:{
                        HStack{
                            KFImage(book.coverURL)
                                .placeholder { ProgressView() }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                            Text("\(book.title)")
                                .monospaced()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}


#Preview {
    SearchView()
        .environmentObject(BookViewModel())
        .preferredColorScheme(.dark)
}
