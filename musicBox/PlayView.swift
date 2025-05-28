//
//  PlayView.swift
//  musicBox
//
//  Created by Biniam Habte on 5/20/25.
//import SwiftUI
import Kingfisher
import Foundation
import SwiftUI

struct PlayView: View {
    @StateObject private var audioMgr = AudioManager.shared
    @EnvironmentObject var viewModel: BookViewModel
    
    let book: Book
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.01, green: 0.02, blue: 0.05),
                    Color(red: 0.1, green: 0.1, blue: 0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
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
                VStack{
                    Slider(
                        value: Binding(
                            get: { audioMgr.currentTime },
                            set: {newTime in
                                audioMgr.seek(to: newTime)
                            }
                        ),
                        in: 0...audioMgr.duration
                    )
                    .frame(width: 350)
                    .tint(.red)
                    .offset(y: -30)
                    
                    if audioMgr.isPlaying {
                        Button{
                            audioMgr.pause()
                        }label: {
                            Text( "Pause")
                                .foregroundStyle(.red)
                                .clipShape(Capsule())
                                .monospaced()
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                                .frame(width: 350, alignment: .center)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.red, lineWidth: 0.75)
                                )
                        }
                    }else {
                        let done = audioMgr.currentTime == 0
                        Button{
                            audioMgr.resume()
                        }label: {
                            Text(done ? "Play":"Resume")
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                                .monospaced()
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                                .frame(width: 350, alignment: .center)
                                .overlay(
                                    Capsule()
                                        .stroke(.indigo, lineWidth: 0.75)
                                )
                        }
                        
                    }
                    
                }.task {
                    let albumReviewURL = audioMgr.getURL(for: book.bookID)
                    audioMgr.startPlaying(for: albumReviewURL)
                }
            }
        }
    }
}

#Preview {
    PlayView(book: Book(
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
