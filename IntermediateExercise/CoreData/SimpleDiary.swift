//
//  SimpleDiary.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/15/26.
//

import SwiftUI
import Combine
import CoreData


class DiaryEntryViewModel: ObservableObject {
    let container: NSPersistentContainer
    
    @Published var savedDiaries: [DiaryEntry] = []
    
    init() {
        container = NSPersistentContainer(name: "DiaryDatabase")
        container.loadPersistentStores { [weak self] (description, error) in
            guard let self else {return}
            if let error {
                print("ERROR LOADING CORE DATA: \(error)")
            } else {
                print("SUCCESSFULLY LOADING CORE DATA: \(description)")
                self.fetchDiaries()
            }
        }
    }
    
    // fetchDiaries()
    private func fetchDiaries() {
        let request = NSFetchRequest<DiaryEntry>(entityName: "DiaryEntry")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DiaryEntry.date, ascending: false)]
        do {
            savedDiaries = try container.viewContext.fetch(request)
        } catch {
            print("ERROR FATCHING CORE DATA: \(error)")
        }
    }
    
    // saveDiary()
    private func saveDiary() {
        do {
            try container.viewContext.save()
            fetchDiaries()
        } catch {
            print("ERROR SAVING IN CORE DATA: \(error)")
        }
    }
    
    // addDiary(diary: DiaryEntry)
    func addDiary(date: Date?, content: String?, mood: Int?) {
        let newDiary = DiaryEntry(context: container.viewContext)
        newDiary.id = UUID()
        newDiary.date = date
        newDiary.content = content
        newDiary.mood = Int16(mood ?? 3)
        newDiary.createdAt = Date()
        saveDiary()
    }
    
    // deleteDiary(diary: DiaryEntry)
    func deleteDiary(diary: DiaryEntry) {
        guard let index = savedDiaries.firstIndex(where: { $0.id == diary.id }) else {return}
        let soonToBeDeletedDiary = savedDiaries[index]
        container.viewContext.delete(soonToBeDeletedDiary)
        saveDiary()
    }
    
    // updateDiary()
    func updateDiary(diaryBefore: DiaryEntry?, date: Date?, content: String?, mood: Int?) {
        guard let diaryDisplayed = diaryBefore,
              let index = savedDiaries.firstIndex(where: { $0.id == diaryDisplayed.id }) else {return}
        savedDiaries[index].date = date
        savedDiaries[index].content = content
        savedDiaries[index].mood = Int16(mood ?? 3)
        saveDiary()
    }
    
}

struct SimpleDiary: View {
    
    @StateObject var vm = DiaryEntryViewModel()
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 30) {
                NavigationLink("새 일기") {
                    DiaryEditorView(
                        selectedDiary: nil
                    )
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(10)
                .padding(.horizontal)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                List {
                    ForEach(vm.savedDiaries, id: \.id) { diary in
                        DiaryCardView(
                            diary: diary
                        )
                    }
                }
            }
            .navigationTitle("나의 일기")
        }
            .environmentObject(vm)
    }
}

struct DiaryCardView: View {
    
    let diary: DiaryEntry
    
    var body: some View {
        NavigationLink {
            DiaryDetailView(selectedDiary: diary)
        } label: {
            VStack {
                HStack {
                    Text(diary.date?.listFormat ?? "날짜 없음")
                    Spacer()
                    likeStarView(diary: diary)
                }
                Text(String(diary.content?.prefix(50) ?? ""))
            }
        }
    }
}

struct DiaryDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var selectedDiary: DiaryEntry
    
    @EnvironmentObject var vm: DiaryEntryViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(selectedDiary.date?.detailFormat ?? "")
            HStack(spacing: 10) {
                Text("기분: ")
                likeStarView(diary: selectedDiary)
            }
            Text(selectedDiary.content ?? "")
        }
        .navigationTitle("일기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("편집") {
                    DiaryEditorView(
                        selectedDiary: selectedDiary
                    )
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("삭제") {
                    vm.deleteDiary(diary: selectedDiary)
                    dismiss()
                }
            }
        }
    }
}

struct DiaryEditorView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: DiaryEntryViewModel
    
    @State var selectedDate: Date
    @State var selectedContent: String
    @State var selectedMood: Int
    
    var selectedDiary: DiaryEntry?
    
    init(selectedDiary: DiaryEntry?) {
        self.selectedDiary = selectedDiary
        _selectedDate = State(initialValue: selectedDiary?.date ?? Date())
        _selectedContent = State(initialValue: selectedDiary?.content ?? "")
        _selectedMood = State(initialValue: Int(selectedDiary?.mood ?? 3))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
            
            Picker("별점 선택", selection: $selectedMood) {
                ForEach(1..<6) { numberOfStars in
                    Text("\(numberOfStars)")
                        .tag(numberOfStars)
                }
            }
            .pickerStyle(.segmented)
            
            TextEditor(text: $selectedContent)
                .textEditorStyle(.plain)
            
            Button("저장") {
                if selectedDiary == nil {
                    vm.addDiary(date: selectedDate, content: selectedContent, mood: selectedMood)
                } else {
                    vm.updateDiary(diaryBefore: selectedDiary, date: selectedDate, content: selectedContent, mood: selectedMood)
                }
                dismiss()
            }
        }
    }
}

#Preview {
    SimpleDiary()
}


extension Date {
    var listFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
    
    var detailFormat: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter.string(from: self)
    }
}

struct likeStarView: View {
    
    let diary: DiaryEntry
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(1..<6, id: \.self) { numberOfStars in
                if numberOfStars <= diary.mood {
                    Text("⭐️")
                } else {
                    Text("☆")
                }
            }
        }
    }
}
    

