//
//  PhotoPickerViewModel.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 3/21/24.
//

import SwiftUI
import PhotosUI
@MainActor
final class PhotoPickerViewModal: ObservableObject {
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    @Published private(set) var selectedImages: [UIImage] = []
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            setImages(from: imageSelections)
        }
    }
    
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                guard let data, let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse) //write my own error
                }
                selectedImage = uiImage
            } catch {
                print(error)
            }
        }
        imageSelection = nil
    }
    
    private func setImages(from selections: [PhotosPickerItem]) {
        if selections.isEmpty  { print("nothing chosen"); return }

        Task {
            var images: [UIImage] = []
            for selection in selections {
                if let data = try? await selection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                }
            }
            selectedImages = images
        }
                imageSelections.removeAll(keepingCapacity: true)
    }
    func saveImagesLocally(folderName: String = "UserImageFolder") {
        if selectedImages.isEmpty {
            logManager.shared.logMessage("\(#line) No images to store", .warning)
            return
        }
        
            //convert backgroundImages to Data
            let dir_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(folderName, isDirectory: true)
            
            if !FileManager.default.fileExists(atPath: dir_path.path) {
                do {
                    try FileManager.default.createDirectory(atPath: dir_path.path, withIntermediateDirectories: true, attributes: nil)
    
                    logManager.shared.logMessage("Created Directory: \(dir_path.absoluteString)", .debug)
    
                }
                catch{
                    logManager.shared.logMessage("Error creating user directory \(error.localizedDescription)", .warning)
                }
            }
            
            var startPoint = 1
            var name = "UserImage\(startPoint).jpg"
            for userImage in selectedImages {
                let img_dir = dir_path.appendingPathComponent(name)
                logManager.shared.logMessage("Saving file to path: \(img_dir.absoluteString)", .debug)
                do {
                    try userImage.jpegData(compressionQuality: 50)?.write(to: img_dir)
                }
                catch {
                    logManager.shared.logMessage("Failed to save image err:"+error.localizedDescription, .warning)
                }
                startPoint+=1
                name = "UserImage\(startPoint).jpg"
            }
        
    }
}
