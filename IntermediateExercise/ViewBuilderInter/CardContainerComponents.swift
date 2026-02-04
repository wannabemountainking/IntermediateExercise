//
//  CardContainerComponents.swift
//  IntermediateExercise
//
//  Created by yoonie on 2/4/26.
//

import SwiftUI


struct BadgeCard<Content: View>: View {
    
    let icon: String
    let title: String
    let content: Content
    
    init(icon: String, title: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.content = content()
    }
    
    var body: some View {
            
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.title2.bold())
            .frame(height: 40)
            .padding(10)
            .padding(.horizontal, 10)
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
            
            Divider()
            
            content
                .padding()
        }
        .padding()
        .padding(.horizontal)
        .background(Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding()
    }
}

struct CardContainerComponents: View {
    
    var body: some View {
        VStack(spacing: 20) {
            BadgeCard(icon: "star.fill", title: "프리미엄 회원") {
                Text("김도윤님 환영합니다")
                Text("🏛️ 박물관 큐레이터")
            }
            BadgeCard(icon: "megaphone.fill", title: "공지사항") {
                VStack(alignment: .leading, spacing: 40) {
                    Text("새로운 기능이 추가되었습니다")
                    Button("자세히 보기") { }
                }
            }
        }
    }
}

#Preview {
    CardContainerComponents()
}
