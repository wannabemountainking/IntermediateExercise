//
//  BookReadingRecords.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/11/26.
//

import SwiftUI
import Combine
import CoreData



class BookRecordsViewModel: ObservableObject {
    
    enum Status: String, Identifiable, CaseIterable {
        case reading = "읽는 중"
        case completed = "완독"
        case toRead = "읽고 싶음"
        
        var id: String {
            switch self {
            case .reading: return "reading"
            case .completed: return "completed"
            case .toRead: return "toRead"
            }
        }
    }
    
    struct BookData: Identifiable {
        let id = UUID()
        let statusName: String
        var bookRecords: [Book]
        var readingProgress: Double
    }
    
    let container: NSPersistentContainer
    
    @Published var selectedBooks: [Book] = []
    
    init() {
        container = NSPersistentContainer(name: "BookReadingRecords")
        
        container.loadPersistentStores { [weak self] (description, error) in
            guard let self else {return}
            if let error {
                print("Error Loading Core Data: \(error)")
            } else {
                print("Successfully loaded Core Data: \(description)")
            }
        }
    }
    
    //fetching
    private func fetchRecords() {
        let request = NSFetchRequest<Book>(entityName: "Book")
        
        do {
            selectedBooks = try container.viewContext.fetch(request)
        } catch {
            print("Error Fetching Core Data: \(error)")
        }
    }
    
    // saving
    private func saveRecords() {
        do {
            try container.viewContext.save()
            fetchRecords()
        } catch {
            print("Error Saving Core Data: \(error)")
        }
    }
    
    // MARK: - Create, update, delete
    // creating
    func addBookRecords(title: String, author: String, currentPage: Int, totalPages: Int, status: Status) {
        guard currentPage <= totalPages else {
            print("현재 페이지를 잘못 입력했습니다")
            return
        }
        let newBook = Book(context: container.viewContext)
        newBook.id = UUID()
        newBook.addedDate = Date()
        newBook.title = title
        newBook.author = author
        newBook.currentPage = Int16(currentPage)
        newBook.totalPage = Int16(totalPages)
        newBook.status = status.rawValue
        saveRecords()
    }
    
    // deleting
    func deleteRecords(book: Book) {
        container.viewContext.delete(book)
        saveRecords()
    }
    
    // state Updating{
    func updateRecords(book: Book, newStatus: Status) {
        guard let index = selectedBooks.firstIndex(where: { $0.id == book.id }) else {return}
        selectedBooks[index].status = newStatus.rawValue
        saveRecords()
    }

}


struct BookReadingRecords: View {
    
    @State private var bookTitle: String = ""
    @State private var bookAuthor: String = ""
    @State private var currentPageOfBook: String = ""
    @State private var totalPageOfBook: String = ""

    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 5) {
                        Text("책 제목:")
                        TextField("제목 입력...", text: $bookTitle)
                            .withDefaultTextField()
                    }
                    HStack(spacing: 5) {
                        Text("저자:")
                        TextField("저자 입력...", text: $bookAuthor)
                    }
                    HStack(spacing: 5) {
                        Text("페이지:")
                        TextField("현재 페이지", text: $currentPageOfBook)
                        Text("/")
                        TextField("총 페이지", text: $totalPageOfBook)
                    }
                }
                
                HStack(spacing: 5) {
                    Text("상태:")
                    
                    Button("읽는 중") {
                        // 상태 변환 기록 등 // 상태는 Struct로 할 필요가 있음
                    }
                    .withDefaultButton()
                    
                    Button("완독") {
                        // 상태 변환 기록 필요
                    }
                    .withDefaultButton()
                    
                    Button("읽고 싶음") {
                        // 상태 변환 기록 필요
                    }
                    .withDefaultButton()
                }
            }
        }
    }
}

#Preview {
    BookReadingRecords()
}
