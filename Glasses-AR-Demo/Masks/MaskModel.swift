//
//  MaskModel.swift
//  Glasses-AR-Demo
//
//  Created by Иван Абрамов on 25.10.2023.
//

import SwiftUI

struct Mask: Identifiable, Equatable {
    let id = UUID()
    let image: String
    let realityObjectName: String
    let previewImage: Image?
    
    static func loadMasks() -> [Mask] {
        return [Mask(image: "Glasses", realityObjectName: "Glasses", previewImage: nil),
                Mask(image: "PartyGlasses", realityObjectName: "PartyGlasses", previewImage: nil),
                Mask(image: "Cyborg", realityObjectName: "Cyborg", previewImage: nil),
                Mask(image: "Green", realityObjectName: "Green", previewImage: nil)
            ]
    }
}
