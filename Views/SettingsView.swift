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
                }
                Spacer()
                
            }
        }
    }
}

#Preview {
    SettingsView()
}
