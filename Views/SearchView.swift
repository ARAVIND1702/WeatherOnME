//
//  SearchView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 01/09/23.
//

import SwiftUI
import Firebase

struct SearchView: View {
    @State private var fetechedUsers:[User] = []
    @State private var serachText : String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        
            List{
                ForEach(fetechedUsers){user in
                    NavigationLink{
                        ReusableProfileContent(user: user)
                    } label: {
                        Text(user.username)
                            .font(.callout)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Serach User")
        .searchable(text: $serachText)
        .onSubmit(of: .search, {
            Task{await searchUsers()}
        })
        .onChange(of: serachText, perform: {newValue in
            if newValue.isEmpty{
                fetechedUsers = []
            }
        })
        
    
    }
    
    func searchUsers() async {
        do{
            let queryLowerCased = serachText.lowercased()
            let queryUpperCased = serachText.uppercased()
            
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username",isGreaterThanOrEqualTo: queryUpperCased)
                .whereField("username",isLessThanOrEqualTo: "\(queryLowerCased)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            
            await MainActor.run(body:{
                fetechedUsers = users
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
