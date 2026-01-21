//
//  ImageDownloader.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/21/26.
//

import SwiftUI
import Combine


class ImageDownloadViewModel: ObservableObject {
    @Published var downloadedImage: Image = Image("swift")
    
    func fetchImage() async throws -> Image {
        try? await Task.sleep(for: .seconds(3))
        return Image("okey")
    }
}

struct ImageDownloader: View {
    @State private var image: Image = Image("swift")
    @StateObject private var vm = ImageDownloadViewModel()
    
    var body: some View {
        Form {
            Button("download") {
                Task {
                    image = try await vm.fetchImage()
                }
            }
        
            ProgressView(
                timerInterval: Date()...Date().addingTimeInterval(3),
                countsDown: false
            )
            HStack(alignment: .center) {
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

#Preview {
    ImageDownloader()
}
