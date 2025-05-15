//
//  BookModel.swift
//  miniAudible
//
//  Created by Biniam Habte on 5/1/25.
//
import Foundation


struct Book: Identifiable {
    let id = UUID()
    let bookID: Int
    let title: String
    let artist: String
    let releaseYear: Int
    let durationMinutes: Int
    let assetName: String
    let coverURL: URL?
    let progressInMinutes: Double = 0.0
}
