//
//  SelectMaskView.swift
//  Glasses-AR-Demo
//
//  Created by Иван Абрамов on 24.10.2023.
//

import SwiftUI

struct SelectMaskView: View {
    let objects: [Mask]
    @Binding var selectedIndex: Int
    @ObservedObject var previews: MaskLoader = MaskLoader.shared
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                Spacer(minLength: 20)

                ForEach(Array(objects.enumerated()), id: \.offset) { (index, object) in
                    Image(object.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                        .scaleEffect(x: selectedIndex == index ? 1.5 : 1.0,
                                     y: selectedIndex == index ? 1.5 : 1.0)
                        .background(selectedIndex == index ? Color.gray.opacity(0.9) : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .onTapGesture {
                            withAnimation {
                                selectedIndex = index
                            }
                        }
                }
            }
        }.frame(height: 150, alignment: .center)
    }
}

//#if DEBUG
struct ObjectPicker_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
//            ObjectPicker(objects: Object.loadObjects(),
//                         selectedIndex: 0)
        }
    }
}
//#endif
