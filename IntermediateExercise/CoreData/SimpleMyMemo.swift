//
//  SimpleMyMemo.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/9/26.
//

import SwiftUI
import CoreData
import Combine


//viewModel에서 CoreData 구현하기
class SimpleMemoViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    
    @Published var savedEntities: [Memo] = []
    
    init() {
        container = NSPersistentContainer(name: "SimpleMemo")
        container.loadPersistentStores { [weak self] (description, error) in
            guard let self else {return}
            if let error {
                print("Error Loading Core Data: \(error)")
            } else {
                print("SUCCESSFULLY LOADED CORE DATA: \(description)")
                self.fetchMemos()
            }
        }
    }
    
    private func fetchMemos() {
        let request = NSFetchRequest<Memo>(entityName: "Memo")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("ERROR FETCHING MEMOS FROM CORE DATA: \(error)")
        }
    }
    
    func saveMemos() {
        do {
            try container.viewContext.save()
            fetchMemos()
        } catch {
            print("ERROR SAVING MEMO IN CORE DATA: \(error)")
        }
    }
    
    func addMemo(text: String) {
        let newMemo = Memo(context: container.viewContext)
        newMemo.id = UUID()
        newMemo.content = text
        saveMemos()
    }
}


struct SimpleMyMemo: View {
    
    @StateObject private var vm = SimpleMemoViewModel()
    @State private var tfText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("메모를 입력하세요...", text: $tfText)
                .withDefaultTextField()
            
            Button("저장하기") {
                // action saveMemo()
                guard !tfText.isEmpty else {return}
                vm.addMemo(text: tfText)
                tfText = ""
            }
            .withDefaultButton()
            
            List {
                ForEach(vm.savedEntities) { memo in
                    Text(memo.content ?? "메모 없음")
                } //:LOOP
            } //:LIST
        } //:VSTACK
    }//:body
}

#Preview {
    SimpleMyMemo()
}


// MARK: - ViewModifier

struct DefaultTextField: ViewModifier {

    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(.leading)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
}

//TODO: 2. ViewModifier 만들기(커스텀제작)
struct DefaultButtonModifier: ViewModifier {
    
    // TODO: backgroundColor 다르게 적용하기
    let backgroundColor: Color
    // ViewModifier 의 안에서 body를 넣어줘야 하는데 일반적인 body가 아니라 some View를 리턴하는 함수 형태의 body가 필요하다.
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundStyle(.white)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
            .padding()
    }
    
}

extension View {
    func withDefaultTextField() -> some View {
        self.modifier(DefaultTextField())
    }
    func withDefaultButton() -> some View {
        self.modifier(DefaultButtonModifier(backgroundColor: .green))
    }
}
