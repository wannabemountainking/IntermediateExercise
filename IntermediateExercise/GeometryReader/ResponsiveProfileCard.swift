//
//  ResponsiveProfileCard.swift
//  IntermediateExercise
//
//  Created by yoonie on 1/27/26.
//

import SwiftUI


struct Profile {
    let name: String
    let job: String
    let followers: String
    let imageName: String
}

struct ResponsiveProfileCard: View {
    
    let profile = Profile(name: "김도윤", job: "큐레이터", followers: "1.2K", imageName: "swift")
    
    var body: some View {
        GeometryReader { proxy in
//            let _ = print("현재 너비: \(proxy.size.width)")
            let isWideView = proxy.size.width > proxy.size.height
            if isWideView {
                // 가로모드
                HorizontalCardView(profile: profile, proxy: proxy)
            } else {
                // 세로모드
                VerticalCardView(profile: profile)
            }
            
        } //:GEOMETRY
    }//: body
}


struct VerticalCardView: View {
    
    let profile: Profile
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 50) {
                Spacer()
                Image(profile.imageName)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .padding(50)
                    .background(Color.gray.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                VStack(spacing: 30) {
                    Text("Name: \(profile.name)")
                    Text("Job: \(profile.job)")
                }
                Spacer()
                VStack(spacing: 30) {
                    Button("Follow  ❤️ \(profile.followers)") { }
                        .foregroundStyle(.white)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Button("Message") { }
                        .foregroundStyle(.white)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Spacer()
            } //:VSTACK
            .font(.title)
            .padding(25)
            .navigationTitle("세로 모드 - 좁은 화면")
            .navigationBarTitleDisplayMode(.inline)
        } //:NAVIGATION
    }//:body
}

struct HorizontalCardView: View {
    
    let profile: Profile
    let proxy: GeometryProxy
    var imageWidth: Double { proxy.size.width * 0.3 }
    var imageHeight: Double { imageWidth }
    var buttonWidth: Double { proxy.size.width * 0.3}
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 30) {
                Image(profile.imageName)
                    .resizable()
                    .frame(width: imageWidth, height: imageHeight, alignment: .leading)
                    .padding(20)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 30) {
                    VStack(spacing: 10) {
                        Text("Name: \(profile.name)")
                        Text("Job: \(profile.job)")
                    }
                    .padding(.bottom, 30)
                    HStack {
                        Button("Follow ❤️ \(profile.followers)") { }
                            .foregroundStyle(.white)
                            .frame(width: buttonWidth, height: 45)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Spacer()
                        Button("Message") { }
                            .foregroundStyle(.white)
                            .frame(width: buttonWidth, height: 45)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(25)
            .font(.title2)
            .navigationTitle("가로 모드 - 넓은 화면")
            .navigationBarTitleDisplayMode(.inline)
        } //:NAVIGATION
    }//:body
}

#Preview {
    ResponsiveProfileCard()
}
