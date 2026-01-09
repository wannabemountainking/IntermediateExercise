//
//  MyDiary.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/9/26.
//

import SwiftUI
import Combine


struct DiaryEntry: Identifiable {
    let id = UUID()
    let date: Date
    var content: String
    var mood: String?
    var tags: [String]
}

class DiaryViewModel: ObservableObject {
    @Published var currentDiaryEntry: DiaryEntry = DiaryEntry(date: Date(), content: "", tags: [])
    
    let diaryEntries: [DiaryEntry] = [
        // 최근 7일 (복합 문제용 - Happy + 100자 이상 포함)
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 0), // 오늘
            content: "오늘은 정말 뜻깊은 하루였다. 아침 일찍 일어나서 SwiftUI 공부를 시작했는데, TabView 구현하면서 많은 걸 배웠어. 처음엔 에러가 계속 나서 답답했지만 Claude와 함께 차근차근 디버깅하면서 해결했다. 특히 Optional 처리 부분에서 크래시가 났었는데, compactMap과 if let 구문을 제대로 이해하게 됐어. 오후에는 박물관에서 새로운 전시 기획안 초안을 완성했고, 저녁에는 운동까지 했다. 하루가 알차게 보람차게 지나갔어. 이런 날이 많았으면 좋겠다.", // 221자
            mood: "Happy",
            tags: ["코딩", "SwiftUI", "공부", "성취감", "직장"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 1), // 어제
            content: "새벽 5시에 일어나서 러닝 3km 완주했다. 날씨도 좋고 기분도 상쾌했어. 한강변을 달리는데 해가 뜨는 모습이 정말 아름다웠다. 운동 후에 단백질 쉐이크 마시고 샤워하니까 하루가 알차게 시작되는 느낌이다. 요즘 규칙적으로 운동하니까 체력도 좋아지고 스트레스도 많이 줄었어. 앞으로도 꾸준히 해야지.", // 157자
            mood: "Happy",
            tags: ["운동", "러닝", "건강", "아침루틴"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 2),
            content: "박물관에서 새로운 전시 기획안 제출했다. 준비 기간이 짧아서 조금 불안하지만 최선을 다했다.", // 56자
            mood: "Neutral",
            tags: ["직장", "박물관", "전시", "기획"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 3),
            content: "친구들이랑 홍대에서 만나서 저녁 먹고 카페 갔다. 오랜만에 만나서 이야기 정말 많이 했어. 학창시절 추억 이야기하면서 웃다가 요즘 고민거리도 서로 나누고. 친구 중 한 명이 이직 준비 중이라는데 응원해줬어. 다들 각자 자리에서 열심히 살아가고 있어서 자극도 많이 받았다. 스트레스도 많이 풀렸고 에너지 충전된 느낌이야.", // 175자
            mood: "Happy",
            tags: ["친구", "외식", "카페", "일상"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 4),
            content: "프로젝트 마감이 다가오는데 진도가 안 나가서 스트레스 받는다. 집중이 안 돼.", // 44자
            mood: "Sad",
            tags: ["직장", "스트레스", "고민"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 5),
            content: "오랜만에 헬스장 갔다. 3개월 만에 가니까 몸이 너무 힘들었지만 그래도 다녀온 게 뿌듯하다. 벤치프레스랑 스쿼트 위주로 운동했는데 내일 근육통 장난 아니게 올 것 같다. 트레이너님이 자세 교정도 해주시고 운동 계획도 새로 짜주셨어. 이번엔 정말 꾸준히 다닐 거야. 건강 관리 제대로 시작이다!", // 158자
            mood: "Happy",
            tags: ["운동", "헬스", "건강", "시작"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 6),
            content: "집에서 하루 종일 넷플릭스 봤다. 아무것도 안 하고 쉬었더니 좀 회복된 느낌.", // 44자
            mood: nil,
            tags: ["휴식", "넷플릭스", "집"]
        ),
        
        // 지난주 (8-14일 전)
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 8),
            content: "가족들이랑 외식했다. 엄마가 좋아하시는 일식집에 갔는데 음식이 정말 맛있었어. 연어덮밥이랑 우동 시켰는데 신선하고 맛있었다. 오랜만에 가족들과 여유롭게 식사하면서 이야기 나누니까 좋았어. 부모님 건강하시고 동생도 잘 지내고 있어서 다행이다. 이런 시간을 더 자주 가져야겠다.", // 153자
            mood: "Happy",
            tags: ["가족", "외식", "일상"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 10),
            content: "요즘 날씨가 추워져서 감기 걸렸다. 약 먹고 푹 쉬어야겠다.", // 34자
            mood: "Sad",
            tags: ["건강", "감기", "휴식"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 12),
            content: "Python 자동화 스크립트 완성했다. OpenCV로 이미지 처리하는 부분이 까다로웠지만 결국 해냈다. 중국어 회문 텍스트 처리하는 로직이 특히 어려웠는데 여러 번 시도 끝에 성공했어. 박물관 업무 효율이 엄청 올라갈 것 같다. 코딩 공부한 보람이 있네.", // 136자
            mood: "Happy",
            tags: ["코딩", "Python", "자동화", "성취감"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 13),
            content: "그냥 평범한 하루였다.", // 13자
            mood: "Neutral",
            tags: ["일상"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 15),
            content: "점심시간에 동료들과 산책했다. 날씨가 좋아서 기분 전환 제대로 했어.", // 40자
            mood: nil,
            tags: ["산책", "직장", "동료"]
        ),
        
        // 2-3주 전 (16-21일 전)
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 17),
            content: "경주로 주말여행 다녀왔다. 토요일 아침 일찍 KTX 타고 출발해서 첨성대, 불국사, 석굴암 다 둘러봤어. 특히 불국사에서 느낀 점이 많았다. 천년이 넘는 유물들을 보면서 큐레이터로서 역사 보존의 중요성을 다시 한번 깨달았어. 날씨도 좋고 사진도 많이 찍었고 정말 힐링되는 시간이었다. 가끔은 이렇게 여행 다녀와야 스트레스가 풀리는 것 같아.", // 194자
            mood: "Happy",
            tags: ["여행", "경주", "역사", "휴식"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 18),
            content: "iOS 앱 개발 강의 듣기 시작했다. UIKit 부분이 생각보다 어렵네.", // 38자
            mood: nil,
            tags: ["코딩", "iOS", "공부", "강의"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 19),
            content: "오늘 하루는 정말 최악이었다. 일도 꼬이고 기분도 안 좋고...", // 34자
            mood: "Sad",
            tags: ["직장", "스트레스"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 21),
            content: "새로운 전시회 오픈했다. 3개월간 준비한 '한국 근대 미술전'이 드디어 문을 열었어. 오프닝 세레모니에 많은 관람객들이 와주셨고 반응이 정말 좋았다. 전시 기획부터 작품 선정, 배치까지 모든 과정에 참여했는데 그 노력이 결실을 맺었다는 게 너무 뿌듯해. 팀원들도 모두 수고했다고 서로 격려했어. 보람찬 하루였다.", // 178자
            mood: "Happy",
            tags: ["직장", "박물관", "전시", "성취감"]
        ),
        
        // 3-4주 전 (22-28일 전)
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 23),
            content: "요가 수업 등록했다. 몸이 너무 굳어있어서 유연성 기르고 싶어.", // 35자
            mood: "Neutral",
            tags: ["운동", "요가", "건강"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 25),
            content: "엄마 생신이라 가족들 모두 모였다. 맛있는 케이크도 사고 선물도 드렸어. 엄마가 정말 좋아하셔서 나도 기분이 좋았다.", // 71자
            mood: "Happy",
            tags: ["가족", "생일", "일상"]
        ),
        
        DiaryEntry(
            date: Date().addingTimeInterval(-86400 * 27),
            content: "회사에서 발표 잘 끝냈다. 긴장했는데 생각보다 잘했어!", // 32자
            mood: "Happy",
            tags: ["직장", "발표", "성취감"]
        )
    ]
    
    var diaryEntriesTuple: [(mood: String, date: String, content: String, tags: String)] {
        diaryEntries.map { diaryEntry in
            let moodLine: String
            switch diaryEntry.mood {
                case "Happy": moodLine = "😊 Happy"
                case "Sad": moodLine = "😥 Sad"
                case "Neutral": moodLine = "😐 Neutral"
                default: moodLine = ""
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "📅 yyyy년 MM월 dd일"
            let dateString = formatter.string(from: diaryEntry.date)
            
            let tagsLine = "🏷️ \(diaryEntry.tags.joined(separator: ", "))"
            return (moodLine, dateString, diaryEntry.content, tagsLine)
        }
    }
    
    var diaryEntriesWithMood: [(mood: String, date: String, content: String, tags: String)] {
        diaryEntriesTuple.compactMap { diaryEntry in
            if diaryEntry.mood != "" {
                return diaryEntry
            } else {
                return nil
            }
        }
    }
}

struct MyDiary: View {
    @StateObject private var vm: DiaryViewModel = DiaryViewModel()
    @State private var showIntro: Bool = true
    
    var body: some View {
        NavigationStack {
            if showIntro {
                DiaryIntroView(showIntro: $showIntro, vm: vm)
                
            }
        }
    }
}

struct DiaryIntroView: View {
    @Binding var showIntro: Bool
    let vm: DiaryViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.diaryEntriesTuple, id: \.date) {
                    Section {
                        Text($0.date)
                        Text($0.content)
                        Text($0.mood)
                        Text($0.tags)
                    }
                }
            }
        }
    }
}

#Preview {
    MyDiary()
}
