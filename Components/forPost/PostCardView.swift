//
//  PostCardView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 21/08/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
/// <#Description#>
struct PostCardView: View {
    var post : Post
    
    var onUpdate:(Post)->()
    var onDelete: () -> ()
    
    @AppStorage("user_UID") var userUID: String = ""
    @State private var docListner: ListenerRegistration?
    
    let dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          return formatter
      }()
    
    var body: some View {
        
        
        VStack(alignment: .leading){
            HStack{
                WebImage(url:post.userProfileURL).placeholder{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color(red: 0.339, green: 0.396, blue: 0.95))
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50,height: 50)
                .clipShape(Circle())
                
//                .overlay(
//                    Circle()
//                        .stroke(Color.black, lineWidth: 2)
//                )
                VStack(alignment: .leading){
                    Text(post.userName)
                        .font(.system(size: 13))
                        .bold()
                    Text(post.publishdedDate.formatted(date: .abbreviated,time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Spacer()
                Menu{
                    if(post.userUID == userUID){
                        Button("Delete",role:.destructive,action: {deletePost()})
                    }
                }label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
                
                
            }.padding(.horizontal)
                .padding(.vertical,5)
                .padding(.top,10)
            Text(post.text)
                .multilineTextAlignment(.leading)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.top,5)
            if let postImageURL = post.imageURl{
                GeometryReader{
                    let size = $0.size
                    WebImage(url:postImageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width,height:size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
                    
                }
                .frame(height:200)
                .padding()
            }
            PostInteraction()
                .padding()
        }
        .frame(maxWidth: .infinity,minHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 20.0).fill(.white))
        .padding(.horizontal)
        .onAppear(){
            if docListner == nil{
                guard let postID = post.id else{return}
                docListner = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({snapshot,error in
                    if let snapshot{
                        if snapshot.exists{
                            if let updatedPost = try? snapshot.data(as:Post.self){
                                onUpdate(updatedPost)
                            }
                        }else{
                            onDelete()
                        }
                    }
                })
            }
        }
        
    }
    
    
    
    
    
    
    @ViewBuilder
    func PostInteraction() -> some View{
        HStack(spacing:6){
            Button{
                likePost()
            }label:{
                Image(systemName: post.likedIDs.contains(userUID) ? "heart.fill" : "heart")
                    .foregroundColor(.gray)
                
            }
            Text("\(post.likedIDs.count )")
                .font(.caption)
                .foregroundColor(.gray)
            Button{}label:{
                Image(systemName: "message.fill")
                    .foregroundColor(.gray)
                
            }
            Text("\(post.dislikedIDs.count)")
                .font(.caption)
                .foregroundColor(.gray)
            
        }
    }
    
///like post
    func likePost(){
        Task{
            guard let postID = post.id else {return}
            if post.likedIDs.contains(userUID){
                Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID])
                ])
            }
            else{
                Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([userUID])
                ])
            }
                
                
        }
    }
    
    func deletePost(){
        Task{
            do{
                if post.imageRefernceID != "" {
                    try await Storage.storage().reference().child("Post_Images").child(post.imageRefernceID).delete()
                }
                guard let postID = post.id else{return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    
}

//struct PostCardView_Previews: PreviewProvider {
//    static var previews: some View {
//                     PostCardView{ updatedPost in
//
//                     } onDelete: {
//
//                     }
//    }
//}
