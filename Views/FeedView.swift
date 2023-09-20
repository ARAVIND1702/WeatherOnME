//
//  FeedView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
struct FeedView: View {
    @State private var myprofile:User?
    @State private var recentsPosts: [Post] = []
    @State private var createNewPost : Bool = false
    @State var postTextForTrigger: String = ""
    @FocusState private var isViewVisible : Bool

    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var usernamestored: String = ""
    
    
    var body: some View {
        NavigationStack{
        VStack{
            HStack(spacing:2){
                WebImage(url:profileURL).placeholder{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color(red: 0.339, green: 0.396, blue: 0.95))
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60,height: 60)
                .clipShape(Circle())
                
//                .overlay(
//                    Circle()
//                        .stroke(Color.black, lineWidth: 2)
//                )
                Spacer()
                VStack{
                    TextField("What's happening?", text: $postTextForTrigger)
                                    .padding(.horizontal)
                                    .padding(.vertical, 9)
                                    .focused($isViewVisible)
                                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                                        if isViewVisible {
                                                                createNewPost = true
                                                                isViewVisible=false
                                                                }
                                        
                                    }
                                    
//                                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
//                                        createNewPost = false
//                                    }
                 


                }
                    .background(RoundedRectangle(cornerRadius: 10.0).fill(.white))
                    .shadow(color:.black.opacity(0.1),radius: 3,y:4)

            }
            .padding()
            Spacer()
            ReusablePostsView(posts: $recentsPosts)
        }
        .fullScreenCover(isPresented: $createNewPost){
            CreatePost{ post in
                recentsPosts.insert(post, at: 0)
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                HStack{
                    Text("Welcome,")
                    Text(usernamestored)
                        .fontWeight(.bold)
                }
                
            }
            ToolbarItem(placement: .navigationBarTrailing){
                HStack{
                    NavigationLink{
                        SearchView()
                    }label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .tint(.black)
                    }
                    Image(systemName: "bell.fill")
                        .font(.system(size: 15))

                    Text("5") // Replace "5" with the actual number of notifications
                            .foregroundColor(.white)
                            .font(.caption2)
                            .padding(3)
                            .background(Circle().fill(Color(red: 0.339, green: 0.396, blue: 0.95)
))
                            .offset(x: -16, y: -8)
                }
            }
        }
        .background(Color(red: 0.973, green: 0.972, blue: 0.981))
        
    }
    }
 
   
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
