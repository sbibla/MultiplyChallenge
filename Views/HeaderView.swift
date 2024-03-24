//
//  HeaderView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/19/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.pink)
                .rotationEffect(Angle(degrees: 15))
            VStack {
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
    HeaderView()
//    LoadedImagesView(selectedImages: [UIImage(named: "DefaultImage1.jpg")!, UIImage(named: "DefaultImage2.jpg")!, UIImage(named: "Loading.jpg")!, UIImage(named: "DefaultImage3.jpg")!, UIImage(named: "DefaultImage4.jpg")!,UIImage(named: "DefaultImage5.jpg")!, UIImage(named: "DefaultImage6.jpg")!,UIImage(named: "DefaultImage7.jpg")!, UIImage(named: "DefaultImage8.jpg")!, ])
}
