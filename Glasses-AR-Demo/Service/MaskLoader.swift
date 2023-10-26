//
//  MaskLoader.swift
//  Glasses-AR-Demo
//
//  Created by Иван Абрамов on 25.10.2023.
//

import Foundation
import RealityKit
import simd
import Combine
import UIKit
import SwiftUI
import QuickLookThumbnailing
import RealityKit
import ARKit

public class Face: RealityKit.Entity, RealityKit.HasAnchoring {
    
}

final class MaskLoader: NSObject, ObservableObject {
    static let shared = MaskLoader()
    
    private override init() {}
    
    @Published var images: [Mask] = []
    
    func loadMask(withName path: String, completion: @escaping (Face?) -> Void) {
        DispatchQueue.main.async {
            guard let realityFileURL = Foundation.Bundle(for: Glasses.Face.self).url(forResource: path,
                                                                                     withExtension: "reality") else {
                completion(nil)
                return
            }
            
            let realityFileSceneURL = realityFileURL.appendingPathComponent("Face", isDirectory: false)
            
            do {
                let anchorEntity = try Face.loadAnchor(contentsOf: realityFileSceneURL)
                
                completion(self.createFace(from: anchorEntity))
            } catch {
                completion(nil)
            }
        }
    }
    
    @MainActor
    private func createFace(from anchorEntity: RealityKit.AnchorEntity) -> Face {
        let face = Face()
        face.anchoring = anchorEntity.anchoring
        face.addChild(anchorEntity)
        
        return face
    }
    
    func generateThumbnailRepresentations(name: String) {
        
        // Set up the parameters of the request.
//        guard let url = Foundation.Bundle(for: Glasses.Face.self).url(forResource: path,
//                                                                      withExtension: "reality") else {
//            completion(nil)
//            return
//        }
        
        let maskLoader = MaskLoader.shared
        let arView = ARView(frame: CGRect(origin: .zero, size: CGSize(width: 500, height: 500)))
        
        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(arConfig)
        
        maskLoader.loadMask(withName: name, completion: { faceScene in
            guard let faceScene else {
                return
            }
            
            arView.scene.anchors.append(faceScene)
            arView.snapshot(saveToHDR: true) { image in
                let mask = Mask(image: "image", realityObjectName: "", previewImage: Image(uiImage: image ?? UIImage()))
                
                self.images.append(mask)
            }
        })
//        let size: CGSize = CGSize(width: 100, height: 100)
//        let scale = UIScreen.main.scale
//        
//        // Create the thumbnail request.
//        let request = QLThumbnailGenerator.Request(fileAt: url,
//                                                   size: size,
//                                                   scale: scale,
//                                                   representationTypes: .all)
//        
//        // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
//        let generator = QLThumbnailGenerator.shared
//        generator.generateRepresentations(for: request) { (thumbnail, type, error) in
//            DispatchQueue.main.async {
//                if thumbnail == nil || error != nil {
//                    // Handle the error case gracefully.
//                    completion(nil)
//                } else {
//                    // Display the thumbnail that you created.
//                    let uiImage = thumbnail?.uiImage
//                    completion(Image(uiImage: uiImage ?? UIImage()))
//                    
//                    let mask = Mask(image: "image", tint: Color.blue, realityObjectName: "", previewImage: Image(uiImage: uiImage ?? UIImage()))
//                    
//                    self.images.append(mask)
//                }
//            }
//        }
    }
    
    private let device = MTLCreateSystemDefaultDevice()!
//    func thumbnail(path: String) {
//        guard let url = Foundation.Bundle(for: Glasses.Face.self).url(forResource: path,
//                                                                      withExtension: "reality") else {
//            return
//        }
//        
//        let size: CGSize = CGSize(width: 100, height: 100)
//        let renderer = SCNRenderer(device: device, options: [:])
//        renderer.autoenablesDefaultLighting = true
//        
//        if (url.pathExtension == "scn") {
//            let scene = try? SCNScene(url: url, options: nil)
//            renderer.scene = scene
//        } else {
//            let asset = MDLAsset(url: url)
//            let scene = SCNScene(mdlAsset: asset)
//            renderer.scene = scene
//        }
//        
//        let image = renderer.snapshot(atTime: 1.0, with: size, antialiasingMode: .multisampling4X)
//        let mask = Mask(image: "image", tint: Color.blue, realityObjectName: "", previewImage: Image(uiImage: image))
//        
//        self.images.append(mask)
//    }
}
