//
//  HeaderView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/19/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct HeaderView: View {
    @StateObject var PPviewModelHeader: PhotoPickerViewModal
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.pink)
                .rotationEffect(Angle(degrees: 15))
            VStack {
//                SettingsView()
                HStack {
                    PhotosPicker(selection: $PPviewModelHeader.imageSelections,maxSelectionCount: 50, matching: .any(of: [.images, .screenshots, .panoramas, .bursts, .livePhotos])) {
//                        VStack {
                            Spacer()
                            Text("   ⚙️")
                                .foregroundColor(.black)
                                .font(.system(size: 25))
                        Spacer()
                        Spacer()
    #if DEBUG
//                            LoadedImagesView(selectedImages: PPviewModel.selectedImages)
    #endif
//                        }
                    }
                }
                Text("Multiply Me")
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .bold()
                Text("Multiplication puzzle game")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .padding(.top, 30)
        }
        .frame(width: UIScreen.main.bounds.width*3, height: 300)
        .offset(y: -120)
    }
}


#Preview {
    HeaderView(PPviewModelHeader: PhotoPickerViewModal())
}
