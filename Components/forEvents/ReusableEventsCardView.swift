//
//  ReusableEventsCardView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 28/08/23.
//

import SwiftUI
import Firebase
import FirebaseStorage


struct ReusableEventsCardView: View {
    var event : EventCard
    var onDelete: () -> ()
    @State var fromtime = ""
    @State var totime = ""
    
    @State private var docListner: ListenerRegistration?

    // Use "HH:mm" for 24-hour format, "hh:mm a" for 12-hour format with AM/P
    
    @AppStorage("user_UID") var userUID: String = ""

    var body: some View {
        VStack(alignment: .leading){
            HStack{
                VStack(alignment:.leading){
                    Text(event.title)
                        .font(.system(size: 16))
                        .fontWeight(.heavy)
                        .padding(.bottom,2)
                    Text("\(fromtime) - \(totime) (IST)")
                }
                Spacer()
                Menu{
                    if(event.userUID == userUID){
                        Button("Delete",role: .destructive, action: { deleteEvent()})
                    }
                }label: {
                    Image(systemName: "ellipsis")
                }
                .offset(y:-15)

                
            }
            .padding(.horizontal)
            .padding(.top,13)
            .padding(.bottom,6)
            Text(event.content)
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal)
                .fontWeight(.light)
                .font(.system(size: 12))
            HStack{
                Text(event.venue)
                    .font(.callout)
                    .font(.system(size: 10))
                Spacer()
                Button{}label: {
                    Text(event.category)
                        .font(.callout)
                        .padding(.horizontal,15)
                        .padding(.vertical,3)
                         
                        .background(
                            Capsule()
                                .stroke(Color.white, lineWidth: 1)
                        )

 
                        
                }
            }
            .offset(y:-8)
            .padding(.bottom,4)
            .padding(.horizontal)
        }
       // .onAppear{ timeConverter() }
        .onAppear(){
            timeConverter()
            if docListner == nil{
                guard let EventID = event.id else{return}
                docListner = Firestore.firestore().collection("Events").document(EventID).addSnapshotListener({snapshot,error in
                    if let snapshot{
                        if snapshot.exists{
                            if let updatedPost = try? snapshot.data(as:EventCard.self){
//                                onUpdate(updatedPost)
                            }
                        }else{
                            onDelete()
                        }
                    }
                })
            }
        }
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 10,style: .continuous)
                .fill(Color(red: 0.3411764705882353, green: 0.396078431372549, blue: 0.9490196078431372))
        )
        .padding(.horizontal)
        .padding(.vertical,4)
    }
    
    
    
     func timeConverter(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        fromtime = dateFormatter.string(from: event.fromtime)
        totime = dateFormatter.string(from: event.totime)
        
    }
    
    
    func deleteEvent(){
        Task{
            do{
                
                guard let eventID = event.id else{return}
                try await Firestore.firestore().collection("Events").document(eventID).delete()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

//struct ReusableEventsCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReusableEventsCardView()
//    }
//}
