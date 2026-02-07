//
//  UIAlertControllerWrapping.swift
//  IntermediateExercise
//
//  Created by yoonie on 2/8/26.
//

import SwiftUI


struct AlertControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var inputName: String
    
    let title: String = "이름 입력"
    let message: String = "이름을 입력하세요"
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented && uiViewController.presentedViewController == nil {
            // 1. alertVC 만들기 2. 먼저 만든 uiViewController에 alert를 present
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addTextField { textField in
                textField.placeholder = "여기에 입력..."
                textField.borderStyle = .roundedRect
                textField.font = .systemFont(ofSize: 18, weight: .semibold)
                textField.autocapitalizationType = .none
                textField.autocorrectionType = .no
            }
            alertVC.addAction(
                UIAlertAction(title: "확인", style: .default, handler: { _ in
                    inputName = alertVC.textFields?.first?.text ?? ""
                    isPresented = false
                })
            )
            alertVC.addAction(
                UIAlertAction(title: "취소", style: .cancel, handler: { _ in
//                    inputName = ""
                    isPresented = false
                })
            )
            
            uiViewController.present(alertVC, animated: true)
        } else if !isPresented && uiViewController.presentedViewController != nil {
            uiViewController.dismiss(animated: true)
        }
        
    }
    // Coordinator로 TextField의 Delegate를 쓰면 오히려 문제 발생(이 델리겟은 쓰는 중의 중간 과정이 다 반영되기 때문에)
}

struct UIAlertControllerWrapping: View {
    
    @State private var isPresented: Bool = false
    @State private var inputName: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("입력한 이름: \(inputName)")
                .font(.title3)
                .fontWeight(.semibold)
            Button("이름 입력") {
                isPresented = true
            }
            .background(
                AlertControllerRepresentable(
                    isPresented: $isPresented,
                    inputName: $inputName
                )
                .frame(width: 0, height: 0)
            )
        } //:VSTACK
        .padding(20)
    }//:body
}

#Preview {
    UIAlertControllerWrapping()
}
