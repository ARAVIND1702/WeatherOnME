//
//  LoginView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 14/08/23.
//

import SwiftUI
import Firebase
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
//    @State private var userIsLoggedIn = false
    //
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("log_status") var userIsLoggedIn:Bool = false
    @AppStorage("user_name") var usernamestored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
   
    var body: some View {
        if userIsLoggedIn{
            Home()
        }
        else{
            NavigationView{
                
                
                ZStack(){
                    Color(red: 0.3411764705882353, green: 0.396078431372549, blue: 0.9490196078431372)
                    VStack{
                        Text("B/S/H/")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 40))
                            .offset(y:50)
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 193.6)
                            .offset(y:50)
                        Image("txt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 249.63,height: 26.35)
                            .offset(y:70)
                            .padding()

//                        Text("Community Cloud")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                            .font(.system(size: 50))
//                            .multilineTextAlignment(.center)
                        Spacer()
                        VStack{
                            Text("Login")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 34))
                                .multilineTextAlignment(.leading)
                                .padding(.vertical,16)
                            Text("Welcome back,\n Sign in to continue")
                                .font(.callout)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                

                            
                        }.padding(.vertical)
                        
                        RoundedRectangle(cornerRadius: 12, style: .circular)
                            .foregroundColor(.white) // Set the background color
                            .frame(height: 60) // Adjust the height of the RoundedRectangle
                        
                            .overlay(
                                TextField("Email",text: $email)
                                    .textContentType(.emailAddress)
                                    .foregroundColor(.black)
                                    .padding(.horizontal,16)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()

                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom,14)
                        
                        RoundedRectangle(cornerRadius: 12, style: .circular)
                            .foregroundColor(.white) // Set the background color
                            .frame(height: 60) // Adjust the height of the RoundedRectangle
                        
                            .overlay(
                                SecureField("Password", text: $password)
                                    .foregroundColor(.black) // Set text color
                                    .padding(.horizontal, 16)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()

                            )
                            .padding(.horizontal,24)
                            .padding(.bottom,14)
                        
                        Button(action:Signin, label: { RoundedRectangle(cornerRadius: 12, style: .circular)
                                .strokeBorder(.background) // Set the background color
                                .frame(height: 60)
                                .overlay(
                                    Text("Sign In")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                    
                                )
                                .padding(.horizontal, 24)
                            
                            
                        }
                        )
                        
                        
                        HStack(spacing: -49){
                            Text("Don' have an account? ")
                                .foregroundColor(.white)
                                
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal,24)
                            NavigationLink(destination: SignUp()) {
                                    Text("Create account")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal,24)
                        }
                        }.padding(.top)
                        Spacer()
                    }
//                    .onAppear{
//                        Auth.auth().addStateDidChangeListener{auth, user in
//                            if user != nil {
//                                print(user)
//                            }
//                        }
//                    }
                    
                }
                .overlay{
                    LoadingView(show: $isLoading)
                }                .ignoresSafeArea()
            }
        }
        
    }
//    func Signin(){
//        isLoading = true
//        closeKeyboard()
//        Task{
//            do {
//                try await Auth.auth().signIn(withEmail: email, password: password){user,error in
//                    if user != nil{
//                        userIsLoggedIn = true
//                    }
//                }
//                try await fetchReq()
//            }catch{
//                print(error)
//            }
//
//        }
//
//    }
    
//    func fetchUser() async throws{
//       guard let userUID = Auth.auth().currentUser?.uid else{        print("helpp")
//return}
//       let user = try await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
//
//        await MainActor.run(body:{
//            self.userUID = userUID
//            usernamestored = user.username
//            profileURL = user.userProfileURL
//            isLoading = false
//            print(profileURL!)
//
//        })
//
//    }
    func Signin() {
        isLoading = true
        closeKeyboard()

        Task {
            do {
                // Sign in the user
                let userCredential = try await Auth.auth().signIn(withEmail: email, password: password)
                // User is now signed in
                userIsLoggedIn = true
                // Fetch user data using userCredential.user.uid
                try await fetchUser(uid: userCredential.user.uid)

                isLoading = false
            } catch {
                print(error)
                isLoading = false
            }
        }
    }

    func fetchUser(uid: String) async {
        do {
            let user = try await Firestore.firestore().collection("Users").document(uid).getDocument(as: User.self)
            await MainActor.run {
                // Update your properties using data from the user document
                self.userUID = uid
                usernamestored = user.username
                profileURL = user.userProfileURL
                isLoading = false
            }
        } catch {
            print(error)
            isLoading = false
        }
    }

    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
