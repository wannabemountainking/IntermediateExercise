//
//  UIActivityViewControllerWrapping.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/7/26.
//

import SwiftUI


struct ActivityVCRepresentable: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        // UIViewControllerRepresentable에서는 Coordinator가 꼭 필요한 이유는 ViewController가 Class이기 때문인가?
        activityVC.completionWithItemsHandler = context.coordinator.completionHandler
        
        // 클로저로 직접 작성하기 => 구조체는 값 타입이어서 self를 참조(캡처)할 방법이 없음
//        activityVC.completionWithItemsHandler = { [weak self] type, completed, items, error in
//            guard let self else {return}
//            self.isPresented = false
//        }
        
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented)
    }
    
    class Coordinator: NSObject {
        @Binding var isPresented: Bool
        
        init(isPresented: Binding<Bool>) {
            self._isPresented = isPresented
        }
        
        // 여기서 커스텀으로 후행클로져 만들기
        func completionHandler(
            _ activityType: UIActivity.ActivityType?,
            completed: Bool,
            _ arr: [Any]?,
            _ error: (any Error)?,
        ) -> Void {
            isPresented = false
        }
    }
    
}


struct UIActivityViewControllerWrapping: View {
    let textToShare: String = "SwiftUI에서 UIKit 사용 중!"
    @State private var showShareSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack(spacing: 10) {
                Text("공유할 텍스트:")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(textToShare)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Button("공유하기") {
                showShareSheet = true
            }
            .sheet(isPresented: $showShareSheet) {
                ActivityVCRepresentable(
                    isPresented: $showShareSheet,
                    items: [textToShare]
                )
            }
        }
    }
}

#Preview {
    UIActivityViewControllerWrapping()
}
