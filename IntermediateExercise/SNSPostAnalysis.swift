//
//  SNSPostAnalysis.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/15/26.
//

import SwiftUI
import Combine


struct Post: Identifiable {
    let id = UUID()
    var author: String?
    var content: String
    var likes: Int
    var comments: [Comment]
    var isPublic: Bool
}

struct Comment: Identifiable {
    let id = UUID()
    var author: String?
}

class SNSAnalysisViewModel: ObservableObject {
    
    
    let posts: [Post] = [
        // 1. 일상
        Post(
            author: "김민수",
            content: "오늘 아침 산책하면서 찍은 하늘 진짜 예쁘다 🌅",
            likes: 127,
            comments: [
                Comment(author: "이지은"),
                Comment(author: "박서준"),
                Comment(author: "최유나")
            ],
            isPublic: true
        ),
        
        // 2. 음식
        Post(
            author: "박지민",
            content: "홍대 새로 생긴 파스타집 완전 맛집! 크림파스타 강추 🍝",
            likes: 89,
            comments: [
                Comment(author: "김태희"),
                Comment(author: "정우성")
            ],
            isPublic: true
        ),
        
        // 3. 운동
        Post(
            author: "최강호",
            content: "드디어 5km 30분 돌파! 작년보다 5분 단축 💪",
            likes: 234,
            comments: [
                Comment(author: "이수진"),
                Comment(author: "강동원"),
                Comment(author: "윤아라"),
                Comment(author: "한지민")
            ],
            isPublic: true
        ),
        
        // 4. 여행
        Post(
            author: "이서연",
            content: "제주도 3박4일 다녀왔어요~ 날씨 완벽했음 ☀️🌊",
            likes: 456,
            comments: [
                Comment(author: "박보검"),
                Comment(author: "송혜교"),
                Comment(author: "공유"),
                Comment(author: "수지"),
                Comment(author: "아이유")
            ],
            isPublic: true
        ),
        
        // 5. 공부
        Post(
            author: "정다은",
            content: "SwiftUI 공부 시작한지 한달! 첫 앱 출시 목표 🚀",
            likes: 178,
            comments: [
                Comment(author: "김개발"),
                Comment(author: "이코더")
            ],
            isPublic: true
        ),
        
        // 6. 익명 포스트
        Post(
            author: nil,
            content: "회사 그만두고 싶다... 이직 준비 중",
            likes: 523,
            comments: [
                Comment(author: nil),
                Comment(author: nil),
                Comment(author: "조언자"),
                Comment(author: nil)
            ],
            isPublic: true
        ),
        
        // 7. 반려동물
        Post(
            author: "강하늘",
            content: "우리 멍멍이 미용하고 왔어요 🐶✨",
            likes: 892,
            comments: [
                Comment(author: "김소현"),
                Comment(author: "박신혜"),
                Comment(author: "전지현")
            ],
            isPublic: true
        ),
        
        // 8. 영화/드라마
        Post(
            author: "윤세아",
            content: "어제 본 영화 진짜 최고였다 ㅠㅠ 강추!",
            likes: 67,
            comments: [
                Comment(author: "이동욱")
            ],
            isPublic: true
        ),
        
        // 9. 음악
        Post(
            author: "한소희",
            content: "요즘 이 노래만 무한반복 중 🎵",
            likes: 341,
            comments: [
                Comment(author: "송강"),
                Comment(author: "정호연"),
                Comment(author: "위하준")
            ],
            isPublic: true
        ),
        
        // 10. 카페
        Post(
            author: "서강준",
            content: "성수동 힙한 카페 발견! 인테리어 미쳤다 📸",
            likes: 445,
            comments: [
                Comment(author: "박서준"),
                Comment(author: "김다미")
            ],
            isPublic: true
        ),
        
        // 11. 책
        Post(
            author: "문채원",
            content: "이 책 읽고 인생관 바뀜.. 강력추천",
            likes: 156,
            comments: [
                Comment(author: "이종석")
            ],
            isPublic: true
        ),
        
        // 12. 날씨
        Post(
            author: "박보영",
            content: "비 오는 날엔 파전이지 🌧️🥘",
            likes: 712,
            comments: [
                Comment(author: "박형식"),
                Comment(author: "김유정"),
                Comment(author: "남주혁"),
                Comment(author: "이성경")
            ],
            isPublic: true
        ),
        
        // 13. 직장 (비공개)
        Post(
            author: "김태리",
            content: "오늘 회의 진짜 길었다... 집 가고 싶어",
            likes: 23,
            comments: [
                Comment(author: "홍경")
            ],
            isPublic: false
        ),
        
        // 14. 게임
        Post(
            author: "류준열",
            content: "드디어 다이아 달성! 1년 걸렸네 ㅋㅋ",
            likes: 289,
            comments: [
                Comment(author: "조인성"),
                Comment(author: "하정우")
            ],
            isPublic: true
        ),
        
        // 15. 요리
        Post(
            author: "이나영",
            content: "첫 베이킹 도전! 생각보다 잘 나왔다 🍰",
            likes: 534,
            comments: [
                Comment(author: "원빈"),
                Comment(author: "김혜수"),
                Comment(author: "황정민")
            ],
            isPublic: true
        ),
        
        // 16. 축하
        Post(
            author: "손예진",
            content: "드디어 승진! 다들 축하해줘서 고마워요 🎉",
            likes: 1203,
            comments: [
                Comment(author: "현빈"),
                Comment(author: "서지혜"),
                Comment(author: "김정현"),
                Comment(author: "유연석"),
                Comment(author: "김선호")
            ],
            isPublic: true
        ),
        
        // 17. 고민 (익명)
        Post(
            author: nil,
            content: "연애 고민... 고백할까 말까",
            likes: 678,
            comments: [
                Comment(author: nil),
                Comment(author: nil),
                Comment(author: "연애고수"),
                Comment(author: nil),
                Comment(author: nil)
            ],
            isPublic: true
        ),
        
        // 18. 패션
        Post(
            author: "전혜빈",
            content: "명동에서 산 원피스 너무 예뻐 👗",
            likes: 423,
            comments: [
                Comment(author: "한예슬"),
                Comment(author: "이다희")
            ],
            isPublic: true
        ),
        
        // 19. 공연
        Post(
            author: "조정석",
            content: "뮤지컬 공연 끝! 관객 분들 감사합니다 🎭",
            likes: 2341,
            comments: [
                Comment(author: "신세경"),
                Comment(author: "유이"),
                Comment(author: "이광수"),
                Comment(author: "김종국")
            ],
            isPublic: true
        ),
        
        // 20. 새벽 감성
        Post(
            author: "정유미",
            content: "새벽 3시... 잠이 안 온다",
            likes: 156,
            comments: [
                Comment(author: "공효진")
            ],
            isPublic: true
        ),
        
        // 21. 헬스
        Post(
            author: "마동석",
            content: "오늘 벤치프레스 150kg 성공! 💪🔥",
            likes: 3456,
            comments: [
                Comment(author: "이정재"),
                Comment(author: "정우성"),
                Comment(author: "하정우"),
                Comment(author: "황정민"),
                Comment(author: "송강호"),
                Comment(author: "조진웅")
            ],
            isPublic: true
        ),
        
        // 22. 졸업
        Post(
            author: "김고은",
            content: "졸업식! 4년간 수고했어 나자신 🎓",
            likes: 892,
            comments: [
                Comment(author: "이민호"),
                Comment(author: "우도환"),
                Comment(author: "김범")
            ],
            isPublic: true
        ),
        
        // 23. 댓글 없는 포스트
        Post(
            author: "주지훈",
            content: "오늘 하루도 수고했어요 여러분",
            likes: 234,
            comments: [],
            isPublic: true
        ),
        
        // 24. 드라이브
        Post(
            author: "배수지",
            content: "강릉 바다 드라이브 🚗🌊 힐링 그 자체",
            likes: 1567,
            comments: [
                Comment(author: "이종석"),
                Comment(author: "이민호"),
                Comment(author: "김우빈")
            ],
            isPublic: true
        ),
        
        // 25. 좋아요 적은 포스트
        Post(
            author: "윤계상",
            content: "점심 뭐 먹지? 추천 좀",
            likes: 12,
            comments: [
                Comment(author: "이하늬")
            ],
            isPublic: true
        ),
        
        // 26. 전시회
        Post(
            author: "박민영",
            content: "DDP 전시 다녀왔어요~ 사진 찍기 좋아요 📷",
            likes: 678,
            comments: [
                Comment(author: "박서준"),
                Comment(author: "김지원")
            ],
            isPublic: true
        ),
        
        // 27. 비공개 일기
        Post(
            author: "이동욱",
            content: "오늘 기분 좀 안 좋네... 내일은 나아지길",
            likes: 5,
            comments: [],
            isPublic: false
        ),
        
        // 28. 축구
        Post(
            author: "손흥민",
            content: "오늘 경기 응원해주신 분들 감사합니다! ⚽",
            likes: 9876,
            comments: [
                Comment(author: "이강인"),
                Comment(author: "김민재"),
                Comment(author: "황희찬"),
                Comment(author: "이재성"),
                Comment(author: "조규성")
            ],
            isPublic: true
        ),
        
        // 29. 명언
        Post(
            author: nil,
            content: "어제보다 나은 오늘을 살자",
            likes: 445,
            comments: [
                Comment(author: nil),
                Comment(author: "긍정맨")
            ],
            isPublic: true
        ),
        
        // 30. 감사 인사
        Post(
            author: "아이유",
            content: "팬 여러분 덕분에 1위! 정말 감사합니다 💜",
            likes: 15678,
            comments: [
                Comment(author: "팬1"),
                Comment(author: "팬2"),
                Comment(author: "팬3"),
                Comment(author: "팬4"),
                Comment(author: "팬5"),
                Comment(author: "팬6"),
                Comment(author: "팬7")
            ],
            isPublic: true
        )
    ]

    // 1. compactMap: 작성자가 있는 게시물만 추출
    var postsWithAuthor: [Post] {
        posts.filter { $0.author != nil }
    }
    
    // 2. filter: 공개 게시물 중 좋아요 50개 이상인 것만
    var publicPostsWithManyLikes: [Post] {
        posts.filter { $0.isPublic && ($0.likes >= 50) }
    }
    
    // 3. flatMap: 모든 게시물의 댓글을 하나의 배열로 합치기
    var allComments: [Comment] {
        posts.flatMap { $0.comments }
    }
    
    // 4. map → flatMap 차이: 게시물마다 댓글 배열을 map과 flatMap으로 각각 처리했을 때 결과 타입 비교
    var allCommentsArr: [[Comment]] {
        posts.map { $0.comments }
    }
    
    // 5. 복합 체이닝: 공개 게시물 → 좋아요 순 정렬 → 상위 10개 → 작성자명 추출 (nil 제거)
    var favoritesTopTen: [String] {
        posts
            .filter { $0.isPublic }
            .sorted(by: { $0.likes > $1.likes })
            .prefix(10)
            .compactMap { $0.author }
    }
    
}

struct SNSPostAnalysis: View {
    @StateObject private var vm: SNSAnalysisViewModel = SNSAnalysisViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section("작성자가 있는 게시물") {
                    ForEach(vm.postsWithAuthor, id: \.id) { post in
                        Text(post.content)
                        Text(post.author!)
                    }
                    Text("총 \(vm.postsWithAuthor.count)개")
                }
                Section("50개 이상의 좋아요를 가진 공개 게시물") {
                    ForEach(vm.publicPostsWithManyLikes, id: \.id) { post in
                        Text(post.author ?? "무명 씨")
                        Text(post.content)
                    }
                }
                Section("모든 게시물의 댓글 FlatMap") {
                    ForEach(vm.allComments, id: \.id) { comment in
                        Text(comment.author ?? "익명")
                    }
                }
                Section("모든 게시물의 댓글 Map") {
                    ForEach(vm.allCommentsArr.enumerated(), id: \.offset) { index, comments in
                        Text("게시물 \(index + 1): \(comments.count)개 댓글")
                        ForEach(comments, id: \.id) { comment in
                            Text("\(comment.author ?? "익명")")
                        }
                    }
                    
                }
                Section("공개게시물 좋아요 상위 10개 작성자들") {
                    ForEach(vm.favoritesTopTen, id: \.self) { name in
                        Text(name)
                    }
                }
            }
        }
    }
}

#Preview {
    SNSPostAnalysis()
}
