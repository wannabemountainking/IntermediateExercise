//
//  TextScoreSystem.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/5/26.
//


import SwiftUI
import Combine


struct Student: Identifiable {
    let id = UUID()
    let name: String
    var score: Int
    var isPresent: Bool
    
    var grade: String {
        switch self.score {
        case 90...100: return "A"
        case 80..<90: return "B"
        case 70..<80: return "C"
        case 60..<70: return "D"
        case 50..<60: return "E"
        default: return "F"
        }
    }
}

class StudentScoreViewModel: ObservableObject {
    let students = [
        Student(name: "김철수", score: 95, isPresent: true),
        Student(name: "이영희", score: 88, isPresent: true),
        Student(name: "박민수", score: 67, isPresent: false),
        Student(name: "최수지", score: 92, isPresent: true),
        Student(name: "정민호", score: 78, isPresent: true),
        Student(name: "강지훈", score: 45, isPresent: false),
        Student(name: "윤서연", score: 85, isPresent: true),
        Student(name: "임하은", score: 72, isPresent: true),
        Student(name: "조예준", score: 81, isPresent: true),
        Student(name: "한지우", score: 58, isPresent: false),
        Student(name: "송다은", score: 91, isPresent: true),
        Student(name: "오준서", score: 64, isPresent: true),
        Student(name: "장민지", score: 77, isPresent: false),
        Student(name: "배서진", score: 83, isPresent: true),
        Student(name: "신유찬", score: 70, isPresent: true)
    ]
    
    var names: [String] {
        students.map { $0.name }
    }
    var studentsPresent: [Student] {
        students.filter { $0.isPresent }
    }
    var studentsOverScore80: [String] {
        students.filter { $0.score >= 80 }
            .map { $0.name }
    }
    var studentsSorted: [Student] {
        students.sorted(by: { $0.score > $1.score })
    }
    var presentStudentOverScore70: [String] {
        students
            .filter({ $0.isPresent })
            .filter { $0.score >= 70 }
            .sorted(by: { $0.score > $1.score })
            .map { $0.name }
    }
}

struct TextScoreSystem: View {
    @StateObject private var vm: StudentScoreViewModel = StudentScoreViewModel()
    
    var body: some View {
        NavigationStack {
            TabView {
                
                Tab {
                    // content
                    List {
                        ForEach(vm.names, id: \.self) { name in
                            HStack(spacing: 60) {
                                Text(name)
                            }
                            .font(.title3)
                        }
                    }
                } label: {
                    Image(systemName: "person")
                    Text("학생이름")
                }
                
                Tab {
                    // content
                    List {
                        ForEach(vm.studentsPresent) { student in
                            studentCard(student: student)
                        }
                    }
                } label: {
                    Image(systemName: "eye")
                    Text("출석학생")
                }
                
                Tab {
                    // content
                    List {
                        ForEach(vm.studentsOverScore80, id: \.self) { name in
                            studentNames(name: name)
                        }
                    }
                } label: {
                    Image(systemName: "graduationcap")
                    Text("우수학생")
                }
                
                Tab {
                    // content
                    List {
                        ForEach(vm.studentsSorted) { student in
                            studentCard(student: student)
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                    Text("성적순")
                }
                
                Tab {
                    // content
                    List {
                        ForEach(vm.presentStudentOverScore70, id: \.self) { name in
                            studentNames(name: name)
                        }
                    }
                } label: {
                    Image(systemName: "studentdesk")
                    Text("성실학생")
                }
            }
            .navigationTitle("학생목록")
        }
    }
    
    private func studentNames(name: String) -> some View {
        HStack(spacing: 60) {
            Text(name)
        }
        .font(.title3)
    }
    
    private func studentCard(student: Student) -> some View {
        HStack(spacing: 60) {
            Text(student.name)
            Text("\(student.score)점")
            Text(student.grade)
            if student.isPresent {
                Image(systemName: "checkmark")
            }
        }
        .font(.title3)
    }
}

#Preview {
    TextScoreSystem()
}
