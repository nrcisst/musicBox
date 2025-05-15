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
        let mockData = [
            Book(
                bookID: 1546163603,
                title: "WLR",
                artist: "Playboi Carti",
                releaseYear: 2020,
                durationMinutes: 90,
                assetName: "wlr",
                coverURL: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/ba/1e/05/ba1e058e-5637-e53c-563c-f5b9a1a6c344/20UM1IM18331.rgb.jpg/600x600bb.jpg")),
            Book(
                bookID: 98,
                title: "Blonde",
                artist: "Frank Ocean",
                releaseYear: 2016,
                durationMinutes: 60,
                assetName: "blonde",
                coverURL: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/bb/45/68/bb4568f3-68cd-619d-fbcb-4e179916545d/BlondCover-Final.jpg/600x600bb.jpg")),
            Book(
                bookID: 44,
                title: "PARTYNEXTDOOR",
                artist: "PartyNextDoor",
                releaseYear: 2012,
                durationMinutes: 40,
                assetName: "pnd",
                coverURL: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/8b/ac/b2/8bacb2b9-0ff0-ac65-bbe2-58baef5abfcb/27496.jpg/600x600bb.jpg")),
            Book(
                bookID: 69,
                title: "Barter 6",
                artist: "Young Thug",
                releaseYear: 2015,
                durationMinutes: 90,
                assetName: "barter",
                coverURL: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/7f/ab/ba/7fabbae7-d92a-f59e-352b-7b9d1e960feb/075679924872.jpg/600x600bb.jpg")),
                
        ]
        
        self.books = mockData
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
        
        guard let searchURL = URL(string:"https://itunes.apple.com/search?term=\(query)&entity=album&limit=100") else{
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

