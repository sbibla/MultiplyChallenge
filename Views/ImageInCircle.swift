//
//  ImageInCircle.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 4/9/24.
//

import SwiftUI

struct ImageInCircle: View {
    var circleImage: UIImage
    
    var body: some View {
        Image(uiImage: circleImage)
        .resizable()
        .frame(width: 120 , height: 120)
        .aspectRatio(contentMode: .fit)
        .clipShape(Circle())
        .overlay {
                       Circle().stroke(.black, lineWidth: 1)
                   }
                   .shadow(radius: 7)    }
}

#Preview {
    ImageInCircle(circleImage: UIImage(named: "Loading.jpg")!)
}
