//
//  ProfileView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ProfileView: View {
    @State private var myprofile:User?
    @State private var isLoading:Bool = false
    
    @AppStorage("log_status") var userIsLoggedIn:Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                if let myprofile{
                    ReusableProfileContent(user: myprofile)
                        .refreshable {
                            self.myprofile = nil
                            await fetchReq()
                        }
                }
                else{
                    ProgressView()
                }
            }
            
            .overlay{
                LoadingView(show: $isLoading)
            }
            .navigationTitle("My profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button("Logout"){
                            isLoading = true
                            logOutofUser()
                        }
                        Button("Delete Account", role:.destructive){
                            deleteAccount()
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
        }.task {
            if (myprofile != nil)  {return}
            await fetchReq()
        }

    }
    
    
    
    
    func logOutofUser(){
        // Assuming you have already set up Firebase in your project
        // Make sure to import Firebase and configure it properly
        // Perform sign-out
        do {
            try Auth.auth().signOut()
            isLoading = false
            print("User signed out successfully.")
            userIsLoggedIn = false
        } catch let signOutError as NSError {
            isLoading = false
            print("Error signing out: \(signOutError)")
        }

    }
    
    func deleteAccount(){
        isLoading = true
        userIsLoggedIn = false
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                try await Auth.auth().currentUser?.delete()
                isLoading = false
                userIsLoggedIn = false
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchReq() async{
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as:User.self) else {return}
        await MainActor.run(body:{
            myprofile = user
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
