//
//  ContentView.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/10/24.
//

import SwiftUICore
import _PhotosUI_SwiftUI
import SwiftUI


struct ContentView: View {

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?

    var body: some View {
        VStack {

            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
            } else {

                Image(systemName: "photo")
                    .imageScale(.large)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
            }

            Spacer()

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
                    .frame(maxWidth: .infinity)
                    .bold()
                    .padding()
                    .foregroundStyle(.white)
                    .background(.indigo)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
            }
        }
        .padding(.horizontal)
        .onChange(of: selectedItem) { oldItem, newItem in
            Task {
                if let image = try? await newItem?.loadTransferable(type: Image.self) {
                    selectedImage = image
                }
            }
        }
    }
}
