//
//  miniAudibleApp.swift
//  miniAudible
//
//  Created by Biniam Habte on 5/1/25.
//
import Foundation
import SwiftUI

@main
struct musicBoxApp: App {
    @StateObject private var viewModel = BookViewModel()
    @StateObject private var audioMgr = AudioManager.shared

    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                ContentView()
                    .environmentObject(viewModel)
                    .environmentObject(audioMgr)
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BookViewModel())
        .environmentObject(AudioManager.shared)

        .preferredColorScheme(.dark)
}
