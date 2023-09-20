//
//  CarPoolCard.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 07/09/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage

struct CarPoolCard: View {
    var carpool : CarPool
    @State var fromtime = ""
    @State var ReqBtn = ""
    var basedonUId = false
    var onUpdate:(CarPool)->()
    var onDelete: () -> ()

    
    @AppStorage("user_UID") var userUID: String = ""
    @State private var docListner: ListenerRegistration?

    var body: some View {
        VStack{
            HStack{
                Text(carpool.CurrentLocation)
                    .font(.callout.bold())
                Spacer()
                Text(carpool.DropLocation)
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
                WebImage(url:carpool.userProfileURL).placeholder{
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color(red: 0.3411764705882353, green: 0.396078431372549, blue: 0.9490196078431372))
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 42,height: 42)
                .clipShape(Circle())
                VStack(alignment: .leading){
                    Text(carpool.userName)
                        .font(.callout.bold())
                    Text(fromtime)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                Spacer()
                VStack(alignment:.trailing,spacing: 5){
                    Text("No of seats available")
                        .font(.caption)
                    if(carpool.Joined.isEmpty){
                        HStack(spacing: 1){
                            if(carpool.NoofSeats == 4){
                                Image(systemName: "person")
                                    .font(.system(size: 14))
                                Image(systemName: "person")
                                    .font(.system(size: 14))
                                Image(systemName: "person")
                                    .font(.system(size: 14))
                                Image(systemName: "person")
                                    .font(.system(size: 14))
                            }
                            else if(carpool.NoofSeats == 3){

                                Image(systemName: "person")
                                    .font(.system(size: 14))
                                Image(systemName: "person")
                                    .font(.system(size: 14))
                                Image(systemName: "person")
                                    .font(.system(size: 14))
                            }
                            else if(carpool.NoofSeats == 2){

                                Image(systemName: "person")
                                    .font(.system(size: 14))
                                Image(systemName: "person")
                                    .font(.system(size: 14))
                            }
                            else if(carpool.NoofSeats + carpool.Joined.count == 1){
                                Image(systemName: "person")
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    else{
                        HStack(spacing: 1){
                            if(carpool.NoofSeats == 4){
                                if(carpool.Joined.count == 1){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                }
                                if(carpool.Joined.count == 2){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                }
                                if(carpool.Joined.count == 3){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                }
                                if(carpool.Joined.count == 4){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                }
                    
                            }
                            else if(carpool.NoofSeats == 3){
                                if(carpool.Joined.count == 1){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                    
                                }
                                if(carpool.Joined.count == 2){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                   
                                }
                                if(carpool.Joined.count == 3){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                   
                                }
                    
                            }
                            else if(carpool.NoofSeats == 2){
                                
                                if(carpool.Joined.count == 1){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person")
                                        .font(.system(size: 14))
                                  
                                }
                                if(carpool.Joined.count == 2){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                   
                                }
                            }
                            else if(carpool.NoofSeats == 1){
                                if(carpool.Joined.count == 1){
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                  
                                }
                            }
                        }

                    }
                }
            }.padding(.horizontal)
                .padding(.top,4)
            if(!basedonUId){
                HStack{
                    Button(action: {Joined()}){
                        if(carpool.NoofSeats == carpool.Joined.count){
                            Text("Ride is Up")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical,9)
                                .padding(.horizontal,15)
                                
                                .background(
                                    RoundedRectangle(cornerRadius: 8.0)
                                        .fill(Color(.red))
                                        .shadow(color:.black.opacity(0.1) ,radius: 1 ,y:2)
                      
                                    // You can specify a fill color if desired
                                )
                        }
                        else{
                            Text(ReqBtn)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical,9)
                                .padding(.horizontal,15)
                            
                                .background(
                                    RoundedRectangle(cornerRadius: 8.0)
                                        .fill(Color(red: 0.339, green: 0.396, blue: 0.95))
                                        .shadow(color:.black.opacity(0.1) ,radius: 1 ,y:2)

                                    
                                )
                            
                        }
                    }.disabled(carpool.NoofSeats == carpool.Joined.count)
                    Spacer()
                }
                .padding(.top,8)
                .padding(.horizontal)
                .padding(.bottom)
                    
            }
            else{
                Spacer()
                
            }
            
         
            
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color:.black.opacity(0.1),radius: 10,y: 4)// Adjust the color and lineWidth as needed
        )
        .padding()
        .onAppear(){
            
            timeConverter()
            Task{
                guard let carpoolID = carpool.id else {return}
                if carpool.Waiting.contains(userUID){
                    ReqBtn = "Cancel Request"
                }
                else{
                    ReqBtn = "Request Ride"

                }
                    
                    
            }
            if docListner == nil{
                guard let carpoolID = carpool.id else{return}
                docListner = Firestore.firestore().collection("CarPools").document(carpoolID).addSnapshotListener({snapshot,error in
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

    }
    
    func timeConverter(){
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        fromtime = dateFormatter.string(from: carpool.OnDateofTravel)
       
   }
    func Joined(){
        Task{
            guard let carpoolID = carpool.id else {return}
            if carpool.Waiting.contains(userUID){
                Firestore.firestore().collection("CarPools").document(carpoolID).updateData([
                    "Waiting": FieldValue.arrayRemove([userUID])
                ])
                ReqBtn = "Request Ride"
            }
            else{
                Firestore.firestore().collection("CarPools").document(carpoolID).updateData([
                    "Waiting": FieldValue.arrayUnion([userUID])

                ])
                ReqBtn = "Cancel Request"

            }
                
                
        }
    }
}

//struct CarPoolCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CarPoolCard()
//    }
//}
