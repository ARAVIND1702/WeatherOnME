//
//  otherRides.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 13/09/23.
//

import SwiftUI
import Firebase

struct otherRides: View {
    var basedonUId : Bool = false
    var uid : String = ""
    @State var carpools: [CarPool] = []
    
    @State var isFetching: Bool = true
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top,30)
                }else{
                    if carpools.isEmpty{
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top,30)
                    }else{
                        CarPools()
                    }
                }
            }
        }
        .refreshable {
            guard !basedonUId else {return}
            isFetching = true
            carpools = []
            await fetchPosts()
        }
        .task {
            guard carpools.isEmpty else{ return }
            await fetchPosts()
            
        }
    }
    
    @ViewBuilder
    func CarPools()-> some View{
        ForEach(carpools){carpool in
            CarPoolCard(carpool: carpool, basedonUId: basedonUId){updatedCarPool in
                withAnimation(.easeInOut(duration: 0.25)){
                    
                    if let index = carpools.firstIndex(where: { carpool in
                        carpool.id == updatedCarPool.id
                    }){
                        carpools[index].Waiting = updatedCarPool.Waiting
                        carpools[index].Joined = updatedCarPool.Joined
                    }
                    
                }
            }onDelete: {
                withAnimation(.easeInOut(duration: 0.35)){
                    carpools.removeAll{ carpool.id == $0.id}
                }
            }
        }
    }
    
//    func fetchPosts()async{
//        do{
//            var query: Query!
//            query = Firestore.firestore().collection("CarPools")
//
//            if basedonUId{
//                query = query.whereField("Joined",arrayContains: uid)
//            }
//
//            let docs = try await query.getDocuments()
//            let fetchedPosts = docs.documents.compactMap { doc -> CarPool? in
//                try? doc.data(as: CarPool.self)
//            }
//                await MainActor.run(body: {
//                    carpools = fetchedPosts
//                    isFetching = false
//                })
//
//        }
//        catch{
//            print(error)
//            print("hi- error")
//        }
//    }
    func fetchPosts() async {
        do {
            var query: Query!
            query = Firestore.firestore().collection("CarPools")
            
            if basedonUId {
                // Add the "Joined" constraint using "arrayContains"
                query = query.whereField("Joined", arrayContainsAny:[uid])
                query = query.whereField("userUID", isEqualTo: uid)

            }
            
            // Add additional "OR" conditions here
//            let field1Value = "value1" // Replace with your desired field value
//            let field2Value = "value2" // Replace with your desired field value
//
//            // Example "OR" condition 1
//            query = query.whereField("Joined", isEqualTo: uid)
            
            // Example "OR" condition 2
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> CarPool? in
                try? doc.data(as: CarPool.self)
            }
            
            await MainActor.run {
                carpools = fetchedPosts
                isFetching = false
            }
        } catch {
            print(error)
            print("hi - error")
        }
    }

    
}

struct otherRides_Previews: PreviewProvider {
    static var previews: some View {
        otherRides()
    }
}
