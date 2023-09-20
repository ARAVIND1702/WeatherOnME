//
//  ReqList.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 13/09/23.
//

import SwiftUI
import Firebase

struct ReqList: View {
    var basedonUId : Bool = false
    var uid : String = ""
    var arrayofReq:[ReqCard] = []
    @AppStorage("user_UID") var userUID: String = ""

    @State var pools :[CarPool] = []
    @State var isFetching: Bool = true
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top,30)
                }else{
                    if (pools.isEmpty){
                        
                        Text("No Rides")
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
            pools = []
            await fetchReq()
            
        }
        .task {
            guard pools.isEmpty else{ return }
            await fetchReq()
            
        }
    }
    
   
    @ViewBuilder
    func Posts() -> some View {
        VStack { // Use a container view, such as VStack
            ForEach(pools, id: \.id) { pool in
                if(!pool.Waiting.isEmpty){
                    ReqCard(pool:pool){updatedCarPool in
                        withAnimation(.easeInOut(duration: 0.25)){
                            
                            if let index = pools.firstIndex(where: { carpool in
                                carpool.id == updatedCarPool.id
                                
                            }){
                                pools[index].Waiting = updatedCarPool.Waiting
                            }
                            
                        }
                    }onDelete: {
                        withAnimation(.easeInOut(duration: 0.35)){
                            pools.removeAll{ pool.id == $0.id}
                        }
                    }

                }
                else{
                    Text("No Request Found")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
        }
    }


    
    func fetchReq()async{
        do{
            var query: Query!
            query = Firestore.firestore().collection("CarPools")
            
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> CarPool? in
                try? doc.data(as: CarPool.self)
            }
                await MainActor.run(body: {
                    for pool in fetchedPosts{
                        if(pool.userUID == userUID){
                            pools.append(pool)
                        }
                    
                    }
                    print(fetchedPosts[1].Waiting.count)
                    
                    isFetching = false
                })
            
        }
        catch{
            print(error)
            print("hi- error")
        }
    }
    
}
