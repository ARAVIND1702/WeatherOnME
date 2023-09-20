//
//  ReqCardItem.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 14/09/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct ReqCardItem: View {
    var pool: CarPool
        var userReq: String // Replace with your actual user type
        var onUpdate: (CarPool) -> ()
        var onDelete: () -> ()
    
        @State var fromtime = ""
        @State var User_Name: String = ""
        @State var profileURL: URL? = URL(string: "")
        @State private var isLoading = false

    @State private var docListner: ListenerRegistration?

    var body: some View {

        VStack{
            HStack{
                Text(pool.CurrentLocation)
                    .font(.callout.bold())
                Spacer()
                Text(pool.DropLocation)
                    .font(.callout.bold())

            }.padding(.horizontal)
             .padding(.top)
            ZStack{
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color(red: 0.8509803921568627, green: 0.8509803921568627, blue: 0.8509803921568627))
                    .frame(height: 6)
                Circle()
                    .fill(.green)
                    .frame(width:16)
                    .offset(x:-150)
                Circle()
                    .fill(.red)
                    .frame(width:16)
                    .offset(x:150)
                Image(systemName: "car.side.fill")
                    .resizable()
                    .scaleEffect(x: -1, y: 1)
                    .aspectRatio( contentMode: .fit)
                    .frame(width: 34)
                    .offset(x: 0, y:0)
                     
            }
            .padding(.horizontal)
            Divider()
            HStack{
                WebImage(url:profileURL).placeholder{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color(red: 0.3411764705882353, green: 0.396078431372549, blue: 0.9490196078431372))
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 42,height: 42)
                .clipShape(Circle())
                VStack(alignment: .leading){
                    Text(User_Name)
                        .font(.callout.bold())
                    Text(fromtime)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                Spacer()
            }.padding(.horizontal)
                .padding(.top,4)
            HStack{
                Spacer()

                Button(action:{Acceept()}){
                    
                    Text("Accept")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical,9)
                        .padding(.horizontal,15)
                    
                        .background(
                            RoundedRectangle(cornerRadius: 8.0)
                                .fill(Color(red: 0.339, green: 0.396, blue: 0.95))
                                .shadow(color:.black.opacity(0.1) ,radius: 1 ,y:2)

                            // You can specify a fill color if desired
                            
                            
                            
                        )
                    
                    
                }
                Button(action:{Ignore()}){
                    
                    Text("Ignore")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical,9)
                        .padding(.horizontal,15)
                    
                        .background(
                            RoundedRectangle(cornerRadius: 8.0)
                                .fill(Color(red: 0.339, green: 0.396, blue: 0.95))
                                .shadow(color:.black.opacity(0.1) ,radius: 1 ,y:2)

                            // You can specify a fill color if desired
                            
                            
                            
                        )
                    
                    
                }

            }
            .padding(.top,8)
            .padding(.horizontal)
            .padding(.bottom)
                
         
            
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color:.black.opacity(0.1),radius: 10,y: 2)// Adjust the color and lineWidth as needed
        ).padding()
            .overlay{
                LoadingView(show: $isLoading)
            }
            .onAppear{
                isLoading = true
                timeConverter()
                Task{
                    do {
                        let user = try await Firestore.firestore().collection("Users").document(userReq).getDocument(as: User.self)

                        await MainActor.run {
                            // Update your properties using data from the user document

                            User_Name = user.username
                            profileURL = user.userProfileURL!
                            
                        }
                        isLoading = false
                    } catch {
                        print(error)
                        isLoading = false
                    }
                    if docListner == nil{
                        docListner = Firestore.firestore().collection("CarPools").document(pool.id!).addSnapshotListener({snapshot,error in
                            if let snapshot{
                                if snapshot.exists{
                                    if let updatedPost = try? snapshot.data(as:CarPool.self){
                                        onUpdate(updatedPost)
                                    }
                                }else{
                                    onDelete()
                                   
                                }
                            }
                        })
                    }
                }
            }    }
    func Acceept(){
        Task{
           // guard let carpoolID = carpool.id else {return}
        
            Firestore.firestore().collection("CarPools").document(pool.id!).updateData([
                    "Joined": FieldValue.arrayUnion([userReq])
                ])
                 Firestore.firestore().collection("CarPools").document(pool.id!).updateData([
                    "Waiting": FieldValue.arrayRemove([userReq])
                ])
                
        }
    }
    func timeConverter(){
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        fromtime = dateFormatter.string(from: pool.OnDateofTravel)
       
   }
    func Ignore(){
        Task{
           // guard let carpoolID = carpool.id else {return}
                 Firestore.firestore().collection("CarPools").document(pool.id!).updateData([
                    "Waiting": FieldValue.arrayRemove([userReq])
                ])
                
        }
    }
}

//struct ReqCardItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ReqCardItem()
//    }
//}
