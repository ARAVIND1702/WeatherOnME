//
//  CreatePost.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//"https://www.goodmorningimagesdownload.com/wp-content/uploads/2021/12/Best-Quality-Profile-Images-Pic-Download-2023.jpg"

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI
import FirebaseFirestoreSwift
import FirebaseStorage
import Firebase
struct CreatePost: View {

    var onPost: (Post)->()

    @State var postText: String = ""
    @State var postImageData : Data?
    
    
    
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("log_status") var userIsLoggedIn:Bool = false
    @AppStorage("user_name") var usernamestored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    @Environment(
        \.dismiss) private var dismiss
     @State private var isLoading: Bool = false
     @State private var errorMessage: String = ""
     @State private var showImagePicker: Bool = false
     @State private var photoItem: PhotosPickerItem?
     @FocusState private var showkeyboard: Bool
    
    var body: some View {
        VStack{
            HStack{
                Menu{
                    Button("Cancel", role: .destructive){
                        dismiss()
                    }
                } label: {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    Text("Create Post")
                        .font(.body)
                }
                Spacer()
                Button(action: {createPost()}){
                    Text("Post")
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.all,5)
                        .padding(.horizontal,6)
                    
                        .background(
                            RoundedRectangle(cornerRadius: 8.0)
                                .fill(Color(red: 0.339, green: 0.396, blue: 0.95))
                                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)

                            // You can specify a fill color if desired
                            
                            
                            
                        )
                    
                    
                }.disabled(postText=="")
            }.padding()
            HStack(spacing: 5){
                
                WebImage(url:profileURL).placeholder{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color(red: 0.3411764705882353, green: 0.396078431372549, blue: 0.9490196078431372))
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60,height: 60)
                .clipShape(Circle())
             
                .offset(y:-66 * 2)

                Spacer()
                VStack(alignment: .leading, spacing: 6){
                    ScrollView(.vertical,showsIndicators: false){
                        TextField("Whats happening?", text: $postText,axis: .vertical)
                            .focused($showkeyboard)
                            .padding()
                        if let postImageData, let image = UIImage(data: postImageData){
                            GeometryReader{
                                let size = $0.size
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:size.width, height:size.height)
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                    .overlay(alignment: .topTrailing){
                                        Button{
                                            withAnimation(.easeInOut(duration: 0.25)){
                                                self.postImageData = nil
                                            }
                                        }label:{
                                            Image(systemName: "trash")
                                                .fontWeight(.bold)
                                                .tint(.red)
                                                .padding()
                                        }
                                    }
                            }.clipped()
                                .frame(height: 220)
                                .padding()

                        }
                    }.frame(height: 270)
                        
                    
                    HStack{
                        Button{
                            withAnimation(.easeInOut(duration: 0.35)){
                                
                                showImagePicker.toggle()
                                
                            }
                        }label: {
                            HStack{
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                Text("Add more")
                                    .font(.caption)
                                Spacer()
                            }
                            
                        }
                    }.padding(.vertical,10)
                    
                }.background(RoundedRectangle(cornerRadius: 10.0)
                    .fill(.white))
                .shadow(color:.black.opacity(0.1),radius: 3,y:4)
                .frame(width:270)
                .offset(x:-12)
                
            }.padding()
            VStack(spacing: 15){
                HStack{
                    withAnimation(.easeInOut(duration: 0.35)){

                    Button(action: {}){
                        HStack{
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .foregroundColor(postImageData != nil ? Color(.white) : Color(.black))
                            
                            Text("Photo/Video")
                                .font(.callout)
                                .foregroundColor(postImageData != nil ? Color(.white) : Color(.black))
                                .padding(.all,5)
                                .padding(.horizontal,6)
                            
                        }
                        .padding(.vertical,6)
                        .padding(.horizontal,16)
                        
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(postImageData != nil ? Color(red: 0.339, green: 0.396, blue: 0.95) : Color(.white))
                                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)
                            
                        )
                        
                        // You can specify a fill color if desired
                        
                        
                        
                        
                        
                        
                    }}
                    Button(action: {}){
                        HStack{
                            Image(systemName: "person.fill.badge.plus")
                                .foregroundColor(.black)
                            Text("Tag employee")
                                .font(.callout)
                                .foregroundColor(.black)
                                .padding(.all,5)
                                .padding(.horizontal,6)

                        }
                        .padding(.vertical,6)
                        .padding(.horizontal,12)

                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.white)
                                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)
                            // You can specify a fill color if desired
                            
                            
                            
                        )
                                                
                        
                    }
                        
                }
                HStack{
                    Button(action: {}){
                        HStack{
                            Image(systemName: "calendar.badge.clock.rtl")
                            .foregroundColor(.black)
                            Text("Event")
                                .font(.callout)
                                .foregroundColor(.black)
                                .padding(.all,5)
                                .padding(.horizontal,30)

                        }
                        .padding(.vertical,6)
                        .padding(.horizontal,16)

                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.white) // You can specify fil
                                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)

                            
                            
                        )
                                                
                        
                    }
                    Button(action: {}){
                        HStack{
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.black)
                            Text("Check in")
                                .font(.callout)
                                .foregroundColor(.black)
                                .padding(.all,5)
                                .padding(.horizontal,22)

                        }
                        .padding(.vertical,6)
                        .padding(.horizontal,16)

                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.white)
                            
                                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)

                            
                            
                        )
                                                
                        
                    }
                }
                HStack{
                    Button(action: {}){
                        HStack{
                            Image(systemName: "music.mic")
                                .foregroundColor(.black)
                            Text("Announcement")
                                .font(.callout)
                                .foregroundColor(.black)
                                .padding(.all,5)
                                .padding(.horizontal,1)

                        }
                        .padding(.vertical,6)
                        .padding(.horizontal,11)

                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.white)
                                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)
                             // You can specify a fill color if desired
                            
                            
                            
                        )
                                                
                        
                    }
                    Spacer()
                    
                }.padding(.horizontal)
            }
            Spacer()
            if showkeyboard == true {
                Divider()
                HStack{
                    Spacer()
                    Button{
                        showkeyboard = false
                    }label: {
                        Text("Done")
                    }
                    
                }.padding(.vertical,1)
                    .padding(.horizontal)
            }
            
        }
        .background(Color(red: 0.9725490196078431, green: 0.9803921568627451, blue: 0.981))
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .overlay{
            LoadingView(show: $isLoading)
        }
        .onChange(of: photoItem){
            newvalue in
            if let newvalue{
                Task{
                    if let rawImageData = try? await newvalue.loadTransferable(type: Data.self),
                       let image = UIImage(data: rawImageData),
                       let compressedImageData =  image.jpegData(compressionQuality:0.5){
                        await MainActor.run(body: {
                            postImageData = compressedImageData
                            photoItem = nil
                        })
                    }
                }
            }
        }
    }
    
    func createPost(){
        isLoading = true
        showkeyboard=false
        Task{
            do{
                //guard let profileURL = profileURL else { return }    ////////////////////URL  add when you are adding dp pic for every account //by ARAVIND RM
                
                let imageRefernceId = "\(userUID)\(Date())"
                let storageRef = Storage.storage().reference().child("Post_Images").child(imageRefernceId)
                if let postImageData{
                    let _ = try await storageRef.putDataAsync(postImageData)
                    let downloadURL = try await storageRef.downloadURL()
                    let post = Post(text: postText,imageURl: downloadURL, imageRefernceID:imageRefernceId,userName: usernamestored, userUID: userUID, userProfileURL: profileURL ?? URL(string: "ASDasdas")!)
                    try await createDocumentAtFireBase(post)
                }else{
                    let post = Post(text: postText,userName: usernamestored, userUID: userUID, userProfileURL: profileURL ?? URL(string: "ASDasdas")!)
                    try await createDocumentAtFireBase(post)

                }
                
            }
            catch{
                await setError(error)
            }
        }
    }
    
    func setError(_ error : Error) async{
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            print(errorMessage)
        })
    }
    
    
    func createDocumentAtFireBase(_ post:Post) async throws{
        let doc = Firestore.firestore().collection("Posts").document()
        let _ = try doc.setData(from: post, completion: {
            error in
            if error == nil{
                isLoading = false
                var updatedPost = post
                updatedPost.id = doc.documentID
                onPost(updatedPost)
                dismiss()
            }else{
                isLoading = false
                dismiss()

            }
        })
    }
    
}

var use = User(username: "BSH HOME APPLICANCE GROUP", userBio: "App dev intern @BSH", userUID: "123123", userEmail: "rmaravind@gmail.com", userProfileURL:URL(string: "https://www.goodmorningimagesdownload.com/wp-content/uploads/2021/12/Best-Quality-Profile-Images-Pic-Download-2023.jpg")!)
struct CreatePost_Previews: PreviewProvider {
    static var previews: some View {
        CreatePost{_ in
            
        }
    
    }
}
