//
//  AudioManager.swift
//  musicBox
//
//  Created by Biniam Habte on 5/16/25.
//
import Foundation
import SwiftUI
import AVFoundation


class AudioManager:NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate, ObservableObject{
    static let shared = AudioManager()
    private override init() { super.init() }
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var timer: Timer?
    @Published public var isRecording: Bool = false
    @Published public var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    
    
    
    func configAudioSession(for albumID: Int) {
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            
            try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setMode(.default)
            try audioSession.setActive(true)
            
            Task {
                if await AVAudioApplication.requestRecordPermission() {
                    startRecording(for:albumID)
                } else {
                    print("Need to enable permission to continue")
                }
            }
        }catch {
            print("Failed to set audio session config")
        }
    }
    
    func getURL(for albumID: Int) -> URL {
        let fetchURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let docURL = fetchURLs.first else {
            fatalError("Fatal Error, could not locate document directory")
        }
        
        let fileURL = docURL.appendingPathComponent("\(albumID)_review").appendingPathExtension("m4a")
        
        return fileURL
    }
    
    func seek(to time: TimeInterval){
        player?.currentTime = time
    }
    
    func startRecording(for albumID: Int){
        let fileURL = getURL(for: albumID)
        let settings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1
        ]
        
        do {
            recorder = try AVAudioRecorder(url: fileURL, settings: settings)
            recorder?.delegate = self
            recorder?.prepareToRecord()
            recorder?.record()
            self.isRecording = true
            
            
        }catch {
            print("Error staring record", error)
        }
    }
    
    func stopRecording(){
        guard let recorder = recorder, recorder.isRecording else {return}
        recorder.stop()
        
        DispatchQueue.main.async {
            self.isRecording = false
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        let savedURL = recorder.url
        DispatchQueue.main.async {
            self.isRecording = false
            if flag{print("Successfully saved to \(savedURL.path)")} else{print("Recording stopped unsuccessfully")}
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        DispatchQueue.main.async {
            self.isRecording = false
            print("Encoding error:", error?.localizedDescription ?? "unknown error")
        }
    }
    
    func startPlaying(for fileURL: URL){
        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            self.isPlaying = true
            
            DispatchQueue.main.async {
                self.duration = self.player?.duration ?? 0.0
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){[weak self] _ in
                guard let self = self else {return}
                
                DispatchQueue.main.async {
                    self.currentTime = self.player?.currentTime ?? 0
                }
            }
            
        }catch {
            print("Could not play file")
        }
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: (any Error)?) {
        DispatchQueue.main.sync {
            self.isPlaying = false
            print("Decoding error:", error?.localizedDescription ?? "unknown error")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
        timer = nil
        DispatchQueue.main.async {
            self.isPlaying = false
            self.currentTime = 0
            if flag{print("Successfully played review")} else{print("Player stopped unsuccessfully")}
        }
    }
    
    func stopPlaying() {
        guard let player = player, player.isPlaying else {return}
        player.stop()
        timer?.invalidate()
        timer = nil
        DispatchQueue.main.async {
            self.isPlaying = false
            
        }
    }
    
    func pause() {
        guard let player = player, player.isPlaying else {return}
        player.pause()
        timer?.invalidate()
        timer = nil
        
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
    
    func resume(){
        guard let player = player, !player.isPlaying else {return}
        player.play()

        DispatchQueue.main.async {
            self.isPlaying = true
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){[weak self] _ in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                self.currentTime = self.player?.currentTime ?? 0
            }
        }
        
        
        
    }
    
}

