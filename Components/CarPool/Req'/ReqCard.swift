//
//  ReqCard.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 13/09/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct ReqCard : View {
    var pool : CarPool
    
    
    var onUpdate:(CarPool)->()
    var onDelete: () -> ()
    
    @State var User_Name : String = ""
    @State var profileURL: URL? = URL(string: "")
    @State private var isLoading = false
    
    @State private var docListner: ListenerRegistration?

    var body: some View {
        VStack{
            ForEach(pool.Waiting,id: \.self){ userReq in
               // let userReq = pool.Waiting[index]
                ReqCardItem(pool: pool, userReq: userReq, onUpdate: onUpdate, onDelete: onDelete)

            
        }
}
       
    }
    func Acceept(poolID:String,userID:String){
        Task{
           // guard let carpoolID = carpool.id else {return}
        
                Firestore.firestore().collection("CarPools").document(poolID).updateData([
                    "Joined": FieldValue.arrayUnion([userID])
                ])
                 Firestore.firestore().collection("CarPools").document(poolID).updateData([
                    "Waiting": FieldValue.arrayRemove([userID])
                ])
                
        }
    }
    
    func Ignore(poolID:String,userID:String){
        Task{
           // guard let carpoolID = carpool.id else {return}
                 Firestore.firestore().collection("CarPools").document(poolID).updateData([
                    "Waiting": FieldValue.arrayRemove([userID])
                ])
                
        }
    }
}

//struct ReqCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ReqCard()
//    }
//}
