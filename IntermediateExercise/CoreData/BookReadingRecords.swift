//
//  BookReadingRecords.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/11/26.
//

import SwiftUI
import Combine
import CoreData


enum Status: String, Identifiable, CaseIterable {
    case reading = "읽는 중"
    case completed = "완독"
    case wishlist = "읽고 싶음"
    
    var id: String {
        switch self {
        case .reading: return "reading"
        case .completed: return "completed"
        case .wishlist: return "toRead"
        }
    }
    
    static func stringToStatus(statusString: String) -> Status {
        switch statusString {
        case "읽는 중": return Status.reading
        case "완독": return Status.completed
        case "읽고 싶음": return Status.wishlist
        default: return Status.reading
        }
    }
}

class BookRecordsViewModel: ObservableObject {
    
    struct BookData: Identifiable {
        var id: String {status.id}
        let status: Status
        var bookRecords: [Book]
        var booksProgress: [(book: Book, progress: Double)] {
            bookRecords
                .map { (
                    book: $0,
                    progress: Double($0.currentPage) / Double($0.totalPage)
                ) }
        }
    }
    // bookDataWithProgress
    var bookDataWithProgress: [BookData] {
        let grouped = Dictionary(grouping: selectedBooks) {
            $0.status ?? ""
        }
        
        return grouped
            .map {
                BookData(
                    status: Status.stringToStatus(statusString: $0.key),
                    bookRecords: $0.value.sorted(by: { $0.addedDate ?? Date() < $1.addedDate ?? Date() })
                )
            }
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
                self.fetchRecords()
            }
        }
    }

    //fetching
    func fetchRecords() {
        let request = NSFetchRequest<Book>(entityName: "Book")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Book.title, ascending: false)]
        do {
            selectedBooks = try container.viewContext.fetch(request)
        } catch {
            print("Error Fetching Core Data: \(error)")
        }
    }
    
    // saving
    func saveRecords() {
        do {
            try container.viewContext.save()
            fetchRecords()
        } catch {
            print("Error Saving Core Data: \(error)")
        }
    }
    
    // MARK: - Create, update, delete
    // creating
    func addBookRecords(title: String, author: String, currentPage: Double, totalPages: Double, status: Status) {

        print("addBookRecords 호출됨")
        print("selectedBooks count: \(selectedBooks.count)")
        
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
        print("저장 후 selectedBooks count: \(selectedBooks.count)")
    }
    
    // deleting
    func deleteRecords(book: Book) {
        guard let index = selectedBooks.firstIndex(where: { $0.id == book.id }) else {return}
        let bookThatWillBeDeleted = selectedBooks[index]
        container.viewContext.delete(bookThatWillBeDeleted)
        saveRecords()
    }
    
    // state Updating{
    func updateRecords(bookBefore: Book?, title: String?, author: String?, currentPage: Int?, newStatus: Status) {
        guard let bookDisplayed = bookBefore,
              let index = selectedBooks.firstIndex(where: { $0.id == bookDisplayed.id }) else {return}
        print(selectedBooks[index])
        selectedBooks[index].title = title
        selectedBooks[index].currentPage = Int16(currentPage ?? 0)
        selectedBooks[index].author = author
        selectedBooks[index].status = newStatus.rawValue
        print(selectedBooks[index])
        saveRecords()
    }
}


struct BookReadingRecords: View {
    
    @StateObject private var vm = BookRecordsViewModel()
    @State private var selectedBook: Book? = nil
    
    @State private var bookTitle: String = ""
    @State private var bookAuthor: String = ""
    @State private var currentPageOfBook: String = ""
    @State private var totalPageOfBook: String = ""
    @State private var readingStatus: Status = .reading
    
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
                            .withDefaultTextField()
                    }
                    HStack(spacing: 5) {
                        Text("페이지:")
                        TextField("현재 페이지", text: $currentPageOfBook)
                            .withDefaultTextField()
                        Text("/")
                        TextField("총 페이지", text: $totalPageOfBook)
                            .withDefaultTextField()
                    }
                }
                
                HStack {
                    Text("상태:")
                    
                    Button("읽는 중") {
                        // 상태 변환 기록 등 // 상태는 Struct로 할 필요가 있음
                        readingStatus = .reading
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 40)
                    .padding(.horizontal, 15)
                    .background(readingStatus == .reading ? Color.green : .gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    .padding(10)
                    
                    Button("완독") {
                        // 상태 변환 기록 필요
                        readingStatus = .completed
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 40)
                    .padding(.horizontal, 15)
                    .background(readingStatus == .completed ? Color.green : .gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    .padding(10)
                    
                    Button("읽고 싶음") {
                        // 상태 변환 기록 필요
                        readingStatus = .wishlist
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 40)
                    .padding(.horizontal, 15)
                    .background(readingStatus == .wishlist ? Color.green : .gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    .padding(10)
                }
                
                if selectedBook == nil {
                    Button("추가하기") {
                        // action addBook
                        
                        vm.addBookRecords(
                            title: bookTitle,
                            author: bookAuthor,
                            currentPage: Double(currentPageOfBook) ?? 0.0,
                            totalPages: Double(totalPageOfBook) ?? 0.0,
                            status: readingStatus
                        )
                        bookTitle = ""
                        bookAuthor = ""
                        currentPageOfBook = ""
                        totalPageOfBook = ""
                        readingStatus = .reading
                    }
                    .withDefaultButton()
                } else {
                    Button("수정하기") {
                        vm.updateRecords(bookBefore: selectedBook, title: bookTitle, author: bookAuthor, currentPage: Int(currentPageOfBook), newStatus: readingStatus)
                        selectedBook = nil
                        bookTitle = ""
                        bookAuthor = ""
                        currentPageOfBook = ""
                        totalPageOfBook = ""
                        readingStatus = .reading
                    }
                    .withDefaultButton()
                }
                Divider()
                
                List {
                    ForEach(vm.bookDataWithProgress, id: \.id) { bookData in
                        Section {
                            //content
                            ForEach(bookData.bookRecords, id: \.self) { book in
                                BookRowView(book: book, bookData: bookData)
                                    .onTapGesture(count: 1) {
                                        selectedBook = book
                                        bookTitle = book.title ?? ""
                                        bookAuthor = book.author ?? ""
                                        currentPageOfBook = "\(book.currentPage)"
                                        totalPageOfBook = "\(book.totalPage)"
                                        readingStatus = Status.stringToStatus(statusString: book.status ?? "읽는 중")
                                    }
                            } //:LOOP
                            .onDelete { offsets in
                                guard let index = offsets.first else {return}
                                let soonToBeDeletedBook = bookData.bookRecords[index]
                                vm.deleteRecords(book: soonToBeDeletedBook)
                            }
                        } header: {
                            switch bookData.status  {
                            case .reading:
                                Text("📖 읽는 중 (\(bookData.bookRecords.count))")
                            case .completed:
                                Text("✅ 완독 (\(bookData.bookRecords.count))")
                            case .wishlist:
                                Text("⭐️ 읽고 싶음 (\(bookData.bookRecords.count))")
                            }
                        }//:SECTION
                    } //:LOOP
                } //:LIST
            } //:VSTACK
            .navigationTitle("독서 기록")
            .padding(.horizontal, 20)
        } //:NAVIGATION
    }//: body
}

struct BookRowView: View {
    
    let book: Book
    let bookData: BookRecordsViewModel.BookData
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            Text(book.title ?? "미상")
            Text(book.author ?? "미상")
            switch bookData.status {
            case .reading:
                ProgressView(
                    "\(book.currentPage)/\(book.totalPage)",
                    value: bookData.booksProgress.first(where: { $0.book == book })?.progress ?? 0.0)
            case .completed:
                Text("✓ 완독")
            case .wishlist:
                Text("⭐️")
            }
        } //:VSTACK
    }
}

#Preview {
    BookReadingRecords()
}
