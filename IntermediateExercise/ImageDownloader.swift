//
//  ImageDownloader.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/21/26.
//

import SwiftUI
import Combine


class ImageDownloadViewModel: ObservableObject {
    @Published var downloadedImage: Image?
    @Published var isDownloading = false
    
    func fetchImage() async throws -> Image {
        isDownloading = true
        defer { isDownloading = false }
        
        try? await Task.sleep(for: .seconds(3))
        return Image("okey")
    }
}

struct ImageDownloader: View {
    @StateObject private var vm = ImageDownloadViewModel()
    
    var body: some View {
        Form {
            Button("download") {
                Task {
                    vm.downloadedImage = try await vm.fetchImage()
                }
            }
            .disabled(vm.isDownloading)
            
            if vm.isDownloading {
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("이미지 다운로드 중...")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
            }
            
            if let image = vm.downloadedImage {
                HStack {
                    Spacer()
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ImageDownloader()
}
