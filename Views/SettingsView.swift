//
//  SettingsView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/21/24.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @State private var photosPickerItems: [PhotosPickerItem] = []
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "gear")
                        .font(.system(size: 25))
                        .overlay {
                            PhotosPicker("O", selection: $photosPickerItems,maxSelectionCount: 10, selectionBehavior: .ordered, matching: .images)
                                .frame(minWidth: 100, maxWidth: 100)
                        }
//                    Spacer()
                }
                Spacer()
                
            }
//            LoadedImagesView(selectedImages: [UIImage(named: "DefaultImage1.jpg")!, UIImage(named: "DefaultImage2.jpg")!])
        }
    }
}

struct LoadedImagesView: View {
    var selectedImages: [UIImage] = []
    var body: some View {
        if !selectedImages.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedImages, id: \.self) {image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
//        LoadedImagesView(selectedImages: [UIImage(named: "DefaultImage1.jpg")!, UIImage(named: "DefaultImage2.jpg")!, UIImage(named: "Loading.jpg")!, UIImage(named: "DefaultImage3.jpg")!, UIImage(named: "DefaultImage4.jpg")!,UIImage(named: "DefaultImage5.jpg")!, UIImage(named: "DefaultImage6.jpg")!,UIImage(named: "DefaultImage7.jpg")!, UIImage(named: "DefaultImage8.jpg")!, ])
}
