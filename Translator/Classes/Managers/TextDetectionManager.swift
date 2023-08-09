//
//  TextDetectionManager.swift
//  Translator
//
//  Created by Kyrylo Chernov on 09.08.2023.
//

import UIKit
import Vision

enum TextDetectionError: Error {
    case incorrectImage
    case incorrectResults
}

class TextDetectionManager {
    func recognizeText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw TextDetectionError.incorrectImage
        }
        
        return try await withCheckedThrowingContinuation({ [weak cgImage] continuation in
            guard let cgImage else { return }
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest(completionHandler: { handler, error  in
                if let error {
                    continuation.resume(throwing: error)
                }
                guard let observations = handler.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: TextDetectionError.incorrectResults)
                    return
                }
                let text = observations.compactMap({
                    $0.topCandidates(1).first?.string
                }).joined(separator: " ")
                continuation.resume(returning: text)
                print(text)
            })
            request.recognitionLevel = .accurate
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        })
    }
}
