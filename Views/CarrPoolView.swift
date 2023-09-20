//
//  CarrPoolView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//

import SwiftUI

struct CarrPoolView: View {
    var body: some View {
        ZStack{
            Color(red: 0.973, green: 0.972, blue: 0.981)
                .ignoresSafeArea()
            
            CarPooLanding()
        }
    }
}

struct CarrPoolView_Previews: PreviewProvider {
    static var previews: some View {
        CarrPoolView()
    }
}
