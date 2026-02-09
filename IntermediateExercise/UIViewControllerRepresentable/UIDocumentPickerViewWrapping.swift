//
//  UIDocumentPickerViewWrapping.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/8/26.
//

import SwiftUI
import UniformTypeIdentifiers


struct DocumentPickerRepresentable: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedFileName: String
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let docPicker = getDocPicker()
        docPicker.delegate = context.coordinator
        return docPicker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }
    
    func getDocPicker() -> UIDocumentPickerViewController {
        let docPicker = UIDocumentPickerViewController(
            forOpeningContentTypes: [.pdf, .image, .text]
        )
        return docPicker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented, selectedFileName: $selectedFileName)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var isPresented: Bool
        @Binding var selectedFileName: String
        
        init(isPresented: Binding<Bool>, selectedFileName: Binding<String>) {
            self._isPresented = isPresented
            self._selectedFileName = selectedFileName
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let firstURL = urls.first else {return}
            selectedFileName = firstURL.lastPathComponent
            isPresented = false
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            controller.dismiss(animated: true) { [weak self] in
                guard let self else {return}
                self.isPresented = false
            }
        }
    }
}

struct UIDocumentPickerViewWrapping: View {
    @State private var selectedFileName: String = ""
    @State private var showPicker: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("선택된 파일: \(selectedFileName)")
            Button("파일 선택") {
                showPicker = true
            }
            .sheet(isPresented: $showPicker) {
                DocumentPickerRepresentable(isPresented: $showPicker, selectedFileName: $selectedFileName)
            }
        }
    }
}

#Preview {
    UIDocumentPickerViewWrapping()
}
