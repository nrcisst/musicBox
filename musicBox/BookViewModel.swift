//
//  BookViewModel.swift
//  miniAudible
//
//  Created by Biniam Habte on 5/3/25.
/*
 Name:    Whole Lotta Red = MBID:    2c5de955-68c8-426b-bcc4-31f71d192e18
 Name:    PARTYNEXTDOOR TWO = MBID:    22b1d527-73da-4267-86ac-3be36219e2c7
 Name:    Blonde = MBID:    0da340a0-6ad7-4fc2-a272-6f94393a7831
 Name:    Barter 6 = MBID:    a2c14ca9-2adb-4324-acfa-cc451f0a3cf0
 */
import Foundation

@MainActor
class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var searchResult: [Book] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(){
        isLoading =  true
        loadBooks()
        isLoading = false
    }
    
    
    func loadBooks() {
        self.books = []
    }
    
    func addBookReview(newBook: Book){
        self.books.append(newBook)
    }
    
    func removeBookReview(_ book: Book){
        books.removeAll{ $0.id == book.id }
    }
    
    func fetchBook(matching term: String) async {
        let trim = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let query = trim.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode")
            return}
        
        guard let searchURL = URL(string:"https://itunes.apple.com/search?term=\(query)&entity=album&limit=200") else{
            print("Invalid URL")
            return
        }
        do {
            
            let (data, _) = try await URLSession.shared.data(from: searchURL)
            let response = try JSONDecoder().decode(ITunesResponse.self, from: data)
            
            var seenIDs = Set<Int>()
            var seenNames = Set<String>()
            
            let orderedAlbums = response.results.sorted {
                $0.releaseDate > $1.releaseDate
            }
            
            let uniqueAlbums = orderedAlbums.filter{album in
                guard !seenIDs.contains(album.collectionId), !seenNames.contains(album.collectionName) else {return false}
                seenIDs.insert(album.collectionId)
                seenNames.insert(album.collectionName)
                return true
            }
            
            self.searchResult = uniqueAlbums
                .filter{$0.trackCount > 5}
                .map{ album in
                    
                let highResString = album.artworkUrl100
                    .replacingOccurrences(of: "/100x100",with: "/600x600")

                return Book(
                    bookID: album.collectionId,
                    title: album.collectionName,
                    artist: album.artistName,
                    releaseYear: Int(album.releaseDate.prefix(4)) ?? 0,
                    durationMinutes: (album.trackTimeMillis ?? 0) / 60_000,
                    assetName: "N/A",
                    coverURL: URL(string: highResString)
                )
            }
            
        } catch {
            print("Failed to fetch OR encode")
        }
        
    }
}

