//
//  SmileDetector.swift
//  Glasses-AR-Demo
//
//  Created by Иван Абрамов on 26.10.2023.
//

import UIKit
import SwiftUI
import AVFoundation
import Vision

final class SmileDetector: ObservableObject {
    @Published var hasSmile: Bool = true
    
    func detectSmile(
        in ciImage: CIImage
    ) {
        let faceOptions: [String: Any] = [CIDetectorAccuracyHigh: true]
        let smileOptions: [String: Any] = [
            CIDetectorSmile: true,
            CIDetectorEyeBlink: true
        ]
        let faceDetector = CIDetector(
            ofType: CIDetectorTypeFace,
            context: nil,
            options: faceOptions
        )
        
        let faces = faceDetector?.features(
            in: ciImage,
            options: smileOptions
        )
        
        if let face = faces?.first as? CIFaceFeature {
            DispatchQueue.main.async {
                self.hasSmile = face.hasSmile
            }
        }
    }
}
