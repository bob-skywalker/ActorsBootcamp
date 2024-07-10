//
//  PhotoPickerBootcamp.swift
//  ActorsBootcamp
//
//  Created by Bo Zhong on 7/5/24.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var selectedPickerItems: [PhotosPickerItem] = [] {
        didSet {
            convertsPickerItemToImage(from: selectedPickerItems)
        }
    }
    
    func convertsPickerItemToImage(from selectedPickerItems: [PhotosPickerItem]) {
        guard !selectedPickerItems.isEmpty else { return }
        
        Task {
            var images: [UIImage] = []
            
            for selectedItem in selectedPickerItems {
                do {
                    if let data = try await selectedItem.loadTransferable(type: Data.self) {
                        guard let image = UIImage(data: data) else {
                            throw URLError(.badServerResponse)
                        }
                        images.append((image))
                    }
                } catch {
                    print("Unable to convert Picker Item to UIImage!")
                }
            }
            
            self.selectedImages = images
        }
    }
    
}

struct PhotoPickerBootcamp: View {
    @StateObject private var vm = PhotoPickerViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Hello, World!")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: 50, height: 50)
                    }
                }
                .padding()
            }
            
            PhotosPicker(selection: $vm.selectedPickerItems, matching: .images) {
                Text("Open the Photo Picker")
            }
            .foregroundStyle(.red)
        }
    }
}

#Preview {
    PhotoPickerBootcamp()
}
