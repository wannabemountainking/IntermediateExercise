//
//  LikeDisLikeCard.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/31/26.
//

import SwiftUI
import Combine


struct IDCard: Identifiable {
    let id = UUID()
    var name: String
    var age: Int
    var imageName: String
}

class IDCardViewModel: ObservableObject {
    @Published var idCard: IDCard = IDCard(name: "", age: 0, imageName: "pentagon")
    var idCards: [IDCard] = [
        IDCard(name: "철수", age: 45, imageName: "pencil"),
        IDCard(name: "영희", age: 55, imageName: "eraser"),
        IDCard(name: "영수", age: 49, imageName: "pencil.and.scribble")
    ]
    
    func insert(idCard: IDCard) {
        self.idCards.append(idCard)
    }
    
    func getIDCard(name: String) -> IDCard? {
        guard let index = idCards.firstIndex(where: { $0.name == name }) else {
            print("해당 이름으로는 등록되어 있지 않습니다")
            return nil
        }
        return idCards[index]
    }
    
    func update(idCard: IDCard) {
        guard let index = idCards.firstIndex(where: { $0.id == idCard.id }) else {
            print("해당 IDCard는 등록되지 않은 카드입니다.")
            return
        }
        idCards[index].name = idCard.name
        idCards[index].age = idCard.age
        idCards[index].imageName = idCard.imageName
    }
    
    func remove(index: Int) {
        guard !idCards.isEmpty else {return}
        idCards.remove(at: index)
    }
}

struct LikeDisLikeCard: View {
    
    @StateObject private var vm = IDCardViewModel()
    @State private var offset: CGSize = .zero
    
    private var cardBackgroundColor: Color {
        offset.width == 0 ? Color.white : offset.width < 0 ? Color.red : Color.green
    }
    
    private var cardOpacity: Double {
        max(1.0 - abs(Double(offset.width)) / 120, 0.5)
    }
    
    private var rotationDegrees: Double {
        offset.width < 0 ? max(Double(offset.width) / 20, -15) : min(Double(offset.width) / 20, 15)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.gray.opacity(0.3)
                    .ignoresSafeArea()
                VStack(alignment: .center) {
                    HStack(spacing: 30) {
                        Text(offset.width <= 0 ? "👎" : "❤️")
                        Text(offset.width <= 0 ? "Nope" : "좋아요")
                    }
                    .font(.title.bold())
                    
                    Spacer()
                
                    IDCardView(
                        idCard: vm.idCards[0],
                        cardColor: cardBackgroundColor,
                    )
                    .offset(offset)
                    .rotationEffect(.degrees(rotationDegrees))
                    .opacity(cardOpacity)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.spring()) {
                                    offset = value.translation
                                }
                            }
                            .onEnded { value in
                                withAnimation(.spring()) {
                                    if abs(value.translation.width) > 120 {
                                        offset = CGSize(
                                            width: value.translation.width > 0 ? proxy.size.width + Double.random(in: 10...70) : -proxy.size.width - Double.random(in: 10...70),
                                            height: value.translation.height > 0 ? proxy.size.height + Double.random(in: 10...70) : -proxy.size.height - Double.random(in: 10...70)
                                            )
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            if vm.idCards.count != 1 {
                                                vm.remove(index: 0)
                                            }
                                            offset = .zero
                                        }
                                    } else {
                                        offset = .zero
                                    }
                                }
                            }
                    ) //:Gesture
                    Spacer()
                } //:VSTACK
            } //:ZSTACK
        } //:GEOMETRY
    }//:body
}

struct IDCardView: View {
    
    let idCard: IDCard
    var cardColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(cardColor)
            .overlay(content: {
                VStack {
                    Image(systemName: idCard.imageName)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaledToFit()
                        .padding(30)
                    Spacer()
                    Text("이름: \(idCard.name)")
                        .padding(5)
                    Text("나이: \(idCard.age)")
                    Spacer()
                }
                .font(.title.bold())
            })
            .frame(width: 300, height: 500)
            .shadow(radius: 10, x: 20, y: 20)
            .padding(50)
    }
}

#Preview {
    LikeDisLikeCard()
}
