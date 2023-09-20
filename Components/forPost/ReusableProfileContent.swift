//
//  ReusableProfileContent.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//

import SwiftUI
import SDWebImageSwiftUI
struct ReusableProfileContent: View {
    var user:User
    @State private var fetchedPosts: [Post] = []
    var body: some View {
        ScrollView(.vertical, showsIndicators:  false){
            LazyVStack(alignment: .leading){
                HStack(spacing: 12){
                    WebImage(url:user.userProfileURL).placeholder{
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(Color(red: 0.339, green: 0.396, blue: 0.95))
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80,height: 80)
                    .clipShape(Circle())
//                    .overlay(
//                            Circle()
//                                .stroke(Color.black, lineWidth: 2)
//                            )
                        
                    VStack(alignment: .leading, spacing: 6){
                        Text(user.username)
                            .lineLimit(5)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        Text(user.userBio)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(5)
                            
                    }
                       
                }.padding()
                ReusablePostsView(basedonUId: true,uid: user.userUID, posts: $fetchedPosts)
            }
        }            .background(Color(red: 0.973, green: 0.972, blue: 0.981))

    }
}

var user = User(username: "BSH HOME APPLICANCE GROUP", userBio: "App dev intern @BSH", userUID: "123123", userEmail: "rmaravind@gmail.com", userProfileURL:URL(string: "https://www.goodmorningimagesdownload.com/wp-content/uploads/2021/12/Best-Quality-Profile-Images-Pic-Download-2023.jpg")!)

struct ReusableProfileContent_Previews: PreviewProvider {
    static var previews: some View {
        ReusableProfileContent(user: user)
    }
}
