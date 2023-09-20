//
//  ReusablePostsView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 18/08/23.
//


import SwiftUI
import Firebase
struct ReusablePostsView: View {
    var basedonUId : Bool = false
    var uid : String = ""
    @Binding var posts: [Post]
    
    @State var isFetching: Bool = true
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top,30)
                }else{
                    if posts.isEmpty{
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top,30)
                    }else{
                        Posts()
                    }
                }
            }
        }
        .refreshable {
            guard !basedonUId else {return}
            isFetching = true
            posts = []
            await fetchPosts()
        }
        .task {
            guard posts.isEmpty else{ return }
            await fetchPosts()
            
        }
    }
    
    @ViewBuilder
    func Posts()-> some View{
        ForEach(posts){post in
            PostCardView(post: post){ updatedPost in
                
                withAnimation(.easeInOut(duration: 0.25)){
                    
                    if let index = posts.firstIndex(where: { post in
                        post.id == updatedPost.id
                    }){
                        posts[index].likedIDs = updatedPost.likedIDs
                    }
                    
                }
                
            } onDelete: {
                withAnimation(.easeInOut(duration: 0.35)){
                    posts.removeAll{ post.id == $0.id}
                }
            }
        }
    }
    
    func fetchPosts()async{
        do{
            var query: Query!
            query = Firestore.firestore().collection("Posts")
            
            if basedonUId{
                query = query.whereField("userUID", isEqualTo: uid)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
                await MainActor.run(body: {
                    posts = fetchedPosts
                    isFetching = false
                })
            
        }
        catch{
            print(error)
            print("hi- error")
        }
    }
    
}

//struct ReusablePostsView_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//
//    }
//}
