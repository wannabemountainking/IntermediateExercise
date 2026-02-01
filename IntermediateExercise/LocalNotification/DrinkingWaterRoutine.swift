//
//  DrinkingWaterRoutine.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 2/2/26.
//

import SwiftUI
import Combine
import UserNotifications


enum WaterInterval: String, Identifiable, CaseIterable {
    case none = "선택 안 함"
    case short = "30분마다"
    case medium = "1시간마다"
    case long = "2시간마다"
    
    var id: String {
        switch self {
        case .none: return "0초"
        case .short: return "1800초"
        case .medium: return "3600초"
        case .long: return "7200초"
        }
    }
    
    var value: Double {
        switch self {
        case .none: return 0
        case .short: return 1800
        case .medium: return 3600
        case .long: return 7200
        }
    }
}

class WaterViewModel: ObservableObject {
    @Published var selectedInterval: WaterInterval = WaterInterval.none
    @Published var isAlarmActive: Bool = false
}

struct DrinkingWaterRoutine: View {
    
    @StateObject private var vm = WaterViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("💧 물 마시기 알람 앱")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        
    }
}

#Preview {
    DrinkingWaterRoutine()
}
