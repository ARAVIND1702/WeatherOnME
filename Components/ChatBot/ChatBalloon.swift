//
//  ChatBalloon.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 18/09/23.
//

import SwiftUI

struct ChatBalloon: View {
    var newMessage :String
    var formattedDate :String
    var body: some View {
        ZStack{
            VStack(alignment:.leading){
                Text(newMessage)
                    .padding(.top)
                    .padding(.bottom,5)
                    .padding(.horizontal)
                    .foregroundColor(.white)
//
                Text(formattedDate)
                    .font(.system(size: 10))
                    .padding(.bottom)
                    .padding(.horizontal)
                    .foregroundColor(.white)
            }
        }.background(Color(red: 0.34, green: 0.39, blue: 0.94))
         .cornerRadius(10)
         .padding(.horizontal)    }
}

