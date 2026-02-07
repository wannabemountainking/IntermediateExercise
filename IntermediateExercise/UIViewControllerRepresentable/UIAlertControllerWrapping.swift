//
//  UIAlertControllerWrapping.swift
//  IntermediateExercise
//
//  Created by yoonie on 2/8/26.
//

import SwiftUI


struct AlertControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var name: String
    @Binding var isPresented: Bool
    
    let title: String
    let message: String
    
    func makeUIViewController(context: Context) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { tf in
            let placeholder = NSAttributedString(
                string: "여기에 입력...",
                attributes: [.foregroundColor: UIColor.systemGray5]
            )
            tf.attributedPlaceholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            name = alert.textFields?.first?.text ?? ""
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        }))
        
        return alert
    }
    
    func updateUIViewController(_ uiViewController: UIAlertController, context: Context) {
        
    }
    
}

struct UIAlertControllerWrapping: View {
    
    @State private var inputName: String = ""
    @State private var showAlart: Bool = false
    
    var body: some View {
        VStack {
            Text("입력한 이름: \(inputName)")
            
            Button("이름 입력") {
                showAlart = true
            }
            .sheet(isPresented: $showAlart) {
                AlertControllerRepresentable(name: $inputName, isPresented: $showAlart, title: "이름 입력", message: "이름 입력")
            }
        }
    }
}

#Preview {
    UIAlertControllerWrapping()
}
