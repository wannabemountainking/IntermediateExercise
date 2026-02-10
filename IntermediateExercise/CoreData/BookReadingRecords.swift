//
//  BookReadingRecords.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/11/26.
//

import SwiftUI

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
                }
            }
        }
    }
}

#Preview {
    BookReadingRecords()
}
