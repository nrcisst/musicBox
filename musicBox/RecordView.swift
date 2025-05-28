//
//  RecordView.swift
//  musicBox
//
//  Created by Biniam Habte on 5/19/25.
//
import SwiftUI
import Kingfisher
import Foundation

struct RecordView: View {
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
            VStack(spacing: 20) {
                KFImage(book.coverURL)
                    .placeholder { ProgressView() }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 400)
                    .offset(y: -100)
                Text("\(book.title) Review")
                    .font(.title2)
                    .monospaced()
                    .bold()
                    .offset(y: -75)
                
                Button {
                    if audioMgr.isRecording {
                        audioMgr.stopRecording()
                        viewModel.addBookReview(newBook: book)
                    } else {
                        audioMgr.configAudioSession(for: book.bookID)
                    }
                } label: {
                    Text(audioMgr.isRecording ? "Stop" : "Start")
                        .foregroundStyle(audioMgr.isRecording ? .red : .green)
                        .monospaced()
                        .bold()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .overlay(
                            Capsule()
                                .stroke(audioMgr.isRecording ? .red : .green, lineWidth: 0.75)
                        )
                }
            }
        }
    }
}

#Preview {
    RecordView(book: Book(
        bookID: 1546163603,
        title: "WLR",
        artist: "Playboi Carti",
        releaseYear: 2020,
        durationMinutes: 90,
        assetName: "wlr",
        coverURL: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/ba/1e/05/ba1e058e-5637-e53c-563c-f5b9a1a6c344/20UM1IM18331.rgb.jpg/400x400bb.jpg")))
    
        .environmentObject(BookViewModel())
        .preferredColorScheme(.dark)
}
