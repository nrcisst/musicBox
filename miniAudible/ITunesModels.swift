//
//  ITunesModels.swift
//  miniAudible
//
//  Created by Biniam Habte on 5/9/25.
//
import Foundation
import SwiftUI

struct ITunesResponse: Codable {
    let resultCount: Int
    let results: [ITunesAlbum]
}

struct ITunesAlbum: Codable {
    var collectionName: String
    var artistName: String
    var releaseDate: String
    var artworkUrl100: String
    var trackCount: Int
    var trackTimeMillis: Int?
    var collectionId: Int
}
