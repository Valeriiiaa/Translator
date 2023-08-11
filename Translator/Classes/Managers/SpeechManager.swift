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
    
    public func startRecognize(for language: String, textChanged: @escaping (String) -> Void, volumeChanged: @escaping(Float) -> Void) throws {
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
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { [weak self] buffer, time in
            guard let self else { return }
            let volume = self.getVolume(from: buffer, bufferSize: 1024)
            print("[log] volume \(volume)")
            volumeChanged(volume)
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
    
    private func getVolume(from buffer: AVAudioPCMBuffer, bufferSize: Int) -> Float {
        guard let channelData = buffer.floatChannelData?[0] else {
            return 0
        }

        let channelDataArray = Array(UnsafeBufferPointer(start:channelData, count: bufferSize))

        var outEnvelope = [Float]()
        var envelopeState:Float = 0
        let envConstantAtk:Float = 0.16
        let envConstantDec:Float = 0.003

        for sample in channelDataArray {
            let rectified = abs(sample)

            if envelopeState < rectified {
                envelopeState += envConstantAtk * (rectified - envelopeState)
            } else {
                envelopeState += envConstantDec * (rectified - envelopeState)
            }
            outEnvelope.append(envelopeState)
        }

        // 0.007 is the low pass filter to prevent
        // getting the noise entering from the microphone
        if let maxVolume = outEnvelope.max(),
            maxVolume > Float(0.015) {
            return maxVolume
        } else {
            return 0.0
        }
    }
    
    public func stopRecognize() {
        recognitionTask?.cancel()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        speechRecognizer = nil
        self.request = nil
    }
}
