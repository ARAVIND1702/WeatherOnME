//
//  SignUp.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 14/08/23.
//

import SwiftUI
import Firebase
struct SignUp: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var bio = ""
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var isLoading = false

    ////
    @AppStorage("log_status") var userIsLoggedIn:Bool = false
    @AppStorage("user_name") var usernamestored: String = ""
    @AppStorage("user_UID") var userUID: String = ""

    
    func handle(error: Error?) {
            if let error = error {
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    
    var body: some View {
        
        ZStack(){
            Color(red: 0.34, green: 0.39, blue: 0.94)
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
                    .offset(y:60)
                    .padding(.bottom,60)
                HStack{
                    Text("Create Account")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 34))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,24)
                        Spacer()
                }
                
                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .foregroundColor(.white) // Set the background color
                    .frame(height: 60) // Adjust the height of the RoundedRectangle
                
                    .overlay(
                        TextField("Name",text: $name)
                            .foregroundColor(.black)
                            .padding(.horizontal,16)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom,14)
                
                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .foregroundColor(.white) // Set the background color
                    .frame(height: 100) // Adjust the height of the RoundedRectangle
                
                    .overlay(
                        TextField("Bio",text: $bio , axis: .vertical)
                            .frame(minHeight:100)
                            .foregroundColor(.black)
                            .padding(.horizontal,16)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom,14)
                
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
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                    )
                    .padding(.horizontal,24)
                    .padding(.bottom,14)
                
                Button(action:register, label: { RoundedRectangle(cornerRadius: 12, style: .circular)
                        .strokeBorder(.background) // Set the background color
                        .frame(height: 60)
                        .overlay(
                            Text("Register")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                        )
                        .padding(.horizontal, 24)
                    
                    
                }
                )
                
//                Image("logo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 120)
//                    .offset(y:50)
                
                Spacer()
            }
            .overlay{
                LoadingView(show: $isLoading)
            }            .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(errorMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            
        }
        
        .ignoresSafeArea()
        
    }
    func register(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().createUser(withEmail: email, password: password)
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                let user = User(username: name, userBio: bio, userUID: userUID, userEmail: email)
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user,completion: {
                    error in
                    if error == nil{
                        print("saved")
                        usernamestored = name
                        self.userUID = userUID
                        userIsLoggedIn = true
                        isLoading = false
                    }
                })
                }
            catch{
                await print(error)
            }
        }
    }
    
    
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
