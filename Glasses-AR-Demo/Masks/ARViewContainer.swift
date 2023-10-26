//
//  ARViewContainer.swift
//  Glasses-AR-Demo
//
//  Created by Иван Абрамов on 26.10.2023.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    private let maskLoader = MaskLoader.shared
    
    let arView = ARView(
        frame: .zero
    )
    var delegate: ARDelegate? {
        didSet {
            arView.session.delegate = delegate
        }
    }
    
    func makeUIView(context: Context) -> ARView {
        let arConfig = ARFaceTrackingConfiguration()
        arView.session.run(
            arConfig
        )
        
        arView.session.delegate = delegate
        
        return arView
    }
    
    func loadMask(withName name: String) {
        let arConfig = ARFaceTrackingConfiguration()
        arView.scene.anchors.removeAll()
        
        maskLoader.loadMask(withName: name,
                            completion: {
            faceScene in
            guard let faceScene else {
                return
            }
            
            arView.scene.anchors.append(
                faceScene
            )
        })
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}

// MARK: - ARSessionDelegate
extension ARViewContainer  {
    
}

final class ARDelegate: NSObject, ARSessionDelegate, ObservableObject {
    @Published var currentFrame: CIImage? = nil
    
    func session(_ session: ARSession, didUpdate frame: ARFrame
    ) {
        let buffer = frame.capturedImage
        self.currentFrame = CIImage(
            cvPixelBuffer: buffer
        )
    }
}
