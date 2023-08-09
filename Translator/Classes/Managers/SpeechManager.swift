//
//  SpeechManager.swift
//  Translator
//
//  Created by Kyrylo Chernov on 09.08.2023.
//

import Foundation
import Speech

enum SpeechManagerError: Error {
    case noInput
    case notSupported
}

class SpeechManager {
    private let audioEngine: AVAudioEngine
    private var speechRecognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    init() {
        audioEngine = AVAudioEngine()
        requestTranscribePermissions()
    }
    
    private func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    public func startRecognize(for language: String, textChanged: @escaping (String) -> Void) throws {
        guard let speechRecognizer = SFSpeechRecognizer(locale: .init(languageComponents: .init(identifier: language))) else {
            throw SpeechManagerError.notSupported
        }
        guard speechRecognizer.isAvailable else {
            throw SpeechManagerError.notSupported
        }
        self.speechRecognizer = speechRecognizer
        let request = SFSpeechAudioBufferRecognitionRequest()
        self.request = request
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { [weak self] buffer, _ in
            guard let self else { return }
            self.request?.append(buffer)
        })
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { [weak self] response, error in
            guard let self else { return }
            if let error {
                print("[log] speech \(error.localizedDescription)")
            }
            guard let response else { return }
            let text = response.bestTranscription.formattedString
            textChanged(text)
            print("[text] \(text)")
        })
    }
    
    public func stopRecognize() {
        recognitionTask?.cancel()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        speechRecognizer = nil
        self.request = nil
    }
}
