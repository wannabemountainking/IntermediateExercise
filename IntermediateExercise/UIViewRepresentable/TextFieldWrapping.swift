//
//  TextFieldWrapping.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/7/26.
//

import SwiftUI


struct TextFieldRepresentable: UIViewRepresentable {
    @Binding var inputText: String
    
    let placeholder: String
    let placeholderColor: UIColor
    
    func makeUIView(context: Context) -> UITextField {
        let textField = getTextField()
        textField.borderStyle = .roundedRect
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ textField: UITextField, context: Context) {
        guard textField.text != inputText else  {return}
        textField.text = inputText
    }
    
    func makeCoordinator() -> TextFieldCoordinator {
        return TextFieldCoordinator(inputText: $inputText)
    }
    
    //UITextField를 장식하는 것
    func getTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        let placeholderArr = NSAttributedString(string: placeholder, attributes: [.foregroundColor : placeholderColor])
        textField.attributedPlaceholder = placeholderArr
        textField.backgroundColor = .systemGray5
        return textField
    }
    
    class TextFieldCoordinator: NSObject, UITextFieldDelegate {
        @Binding var inputText: String
        
        init(inputText: Binding<String>) {
            self._inputText = inputText
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // 1. currentText 2. nsRange -> swfitRange 3. updatedText 5. text = updatedText
            guard let currentText = textField.text,
                  let range = Range(range, in: currentText) else {return false}
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            inputText = updatedText
            return true
        }
    }
}


struct TextFieldWrapping: View {
    
    @State private var inputText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack(spacing: 10) {
                Text("입력한 텍스트:")
                    .fontWeight(.semibold)
                Text(inputText)
                Spacer()
            }
            .font(.title2)
            
            TextFieldRepresentable(
                inputText: $inputText,
                placeholder: "여기에 입력...",
                placeholderColor: .systemOrange
            )
            .frame(height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button("Clear") {
                inputText = ""
            }
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(10)
            .padding(.horizontal)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
        } //:VSTACK
        .padding(30)
    }//:body
}

#Preview {
    TextFieldWrapping()
}
