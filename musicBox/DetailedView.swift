//
//  DetailedView.swift
//  miniAudible
//
//  Created by Biniam Habte on 5/1/25.
//
import SwiftUI
import Kingfisher



struct DetailedView: View {
    @StateObject private var audioMgr = AudioManager.shared
    @EnvironmentObject var viewModel: BookViewModel

    
    let book: Book
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
            
            ScrollView {
                VStack(alignment: .center, spacing: 15) {
                    KFImage(book.coverURL)
                        .placeholder { ProgressView() }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 400)
                    
                    Text(book.title)
                        .font(.title)
                        .monospaced()
                        .bold()
                    Text(book.artist)
                        .font(.title2)
                        .monospaced()
                        .bold()
                    Text(String(book.releaseYear))
                        .font(.title3)
                        .monospaced()
                        .bold()
                        .padding(.bottom, 35)
                    if viewModel.books.contains(where: {$0.bookID == book.bookID}){
                        HStack{
                                NavigationLink{
                                    PlayView(book: book)
                                }label: {
                                    Text("Play review")
                                        .foregroundStyle(.indigo)
                                        .clipShape(Capsule())
                                        .monospaced()
                                        .bold()
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 20)
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.indigo, lineWidth: 0.75)
                                        )
                                }
                                Button{
                                    viewModel.removeBookReview(book)
                                } label: {
                                    Text("Remove review")
                                        .foregroundStyle(.red)
                                        .clipShape(Capsule())
                                        .monospaced()
                                        .bold()
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 20)
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.red, lineWidth: 0.75)
                                        )
                                }
                        }
                        
                    }else {
                        NavigationLink{
                            RecordView(book: book)
                        } label: {
                            Text("Add review")
                                .foregroundStyle(.white)
                                .background(Color.clear)
                                .clipShape(Capsule())
                                .monospaced()
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.indigo, lineWidth: 0.75)
                                )
                                .offset(x: 3)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    DetailedView(book: Book(
        bookID: 1546163603,
        title: "WLR",
        artist: "Playboi Carti",
        releaseYear: 2020,
        durationMinutes: 90,
        assetName: "wlr",
        coverURL: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/ba/1e/05/ba1e058e-5637-e53c-563c-f5b9a1a6c344/20UM1IM18331.rgb.jpg/400x400bb.jpg")
    ))
    
                 
    .environmentObject(BookViewModel())
    .preferredColorScheme(.dark)
}
