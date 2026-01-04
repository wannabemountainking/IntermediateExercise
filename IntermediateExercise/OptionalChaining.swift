//
//  OptionalChaining.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/4/26.
//

import SwiftUI
import Combine

struct UserAddress {
    var address: AddressInput?
}

struct AddressInput {
    var city: String?
    var zipCode: String?
}

class AddressViewModel: ObservableObject {
    @Published var userAddress: UserAddress = UserAddress()
    @Published var textMessage: String = ""
    
    func setUserAddress(city: String?, zipCode: String?) {
        userAddress = UserAddress(address: AddressInput(city: city, zipCode: zipCode))
    }
    
    func userAddressExists(userAddress: UserAddress) {
        guard let userCity = userAddress.address?.city, !userCity.isEmpty else {
            textMessage = "도시 정보 없음"
            return
        }
        
        guard let userZipCode = userAddress.address?.zipCode, !userZipCode.isEmpty else {
            textMessage = "zip code 정보 없음"
            return
        }
        
        textMessage = userCity
    }
}

struct OptionalChaining: View {
    @StateObject private var vm: AddressViewModel = AddressViewModel()
    @State private var city: String = ""
    @State private var zipCode: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("도시명 입력", text: $city)
                TextField("zip code 입력", text: $zipCode)
                
                Text(vm.textMessage)
                
                Button("주소 확인") {
                    vm.setUserAddress(city: city, zipCode: zipCode)
                    vm.userAddressExists(userAddress: vm.userAddress)
                }
            }
            .navigationTitle("주소를 찾아라")
        }
    }
}

#Preview {
    OptionalChaining()
}
