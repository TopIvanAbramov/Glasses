//
//  ContentView.swift
//  Glasses-AR-Demo
//
//  Created by Ivan Abramov on 23/10/2023
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @State private var isPresented: Bool = false
    @State var selectedIndexMask: Int = 0
    @State var masks: [Mask] = []
    
    @ObservedObject private var arDelegate: ARDelegate
    @ObservedObject var smileDetector = SmileDetector()
    
    private var arView: ARViewContainer
    
    init() {
        masks = Mask.loadMasks()
        arDelegate = ARDelegate()
        arView = ARViewContainer(
            delegate: nil
        )
        arView.delegate = arDelegate
        
        if let firstMask = masks.first {
            arView.loadMask(
                withName: firstMask.realityObjectName
            )
        }
    }
    
    var body: some View {
        ZStack {
            arView
                .edgesIgnoringSafeArea(
                    .all
                )
                .alert(
                    "Face Tracking Unavailable",
                    isPresented: $isPresented
                ) {
                    Button {
                        isPresented = false
                    } label: {
                        Text(
                            "Okay"
                        )
                    }
                } message: {
                    Text(
                        "Face tracking requires an iPhone X or later."
                    )
                }
                .onAppear {
                    if !ARFaceTrackingConfiguration.isSupported {
                        isPresented = true
                    }
                }
                .onChange(
                    of: arDelegate.currentFrame
                ) { value in
                    if let value {
                        smileDetector.detectSmile(
                            in: value
                        )
                    }
                }
            
            VStack {
                Spacer()
                SelectMaskView(
                    objects: Mask.loadMasks(),
                    selectedIndex: $selectedIndexMask
                )
                .frame(
                    alignment: .bottom
                )
                .padding(
                    .bottom,
                    30
                )
                .onChange(
                    of: selectedIndexMask
                ) { newValue in
                    arView.loadMask(
                        withName: masks[newValue].realityObjectName
                    )
                }
            }
            
            
            VStack {
                Text(
                    smileDetector.hasSmile ? "😀" : "😐"
                )
                .font(
                    .system(
                        size: 100,
                        weight: .bold
                    )
                )
                .multilineTextAlignment(
                    .center
                )
                .frame(
                    alignment: .top
                )
                
                Spacer()
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            ContentView()
        }
    }
}
#endif
