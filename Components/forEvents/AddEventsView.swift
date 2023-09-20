//
//  AddEventsView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 01/09/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseStorage
import Firebase

struct AddEventsView: View {
    @Environment(\.dismiss) var dismiss

    @State var selectedDate: Date?
    @State private var FromTime = Date()
    @State private var ToTime = Date()
    @State var EventDate =  ""
    
    let dateFormatter = DateFormatter()
    
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("log_status") var userIsLoggedIn:Bool = false
    @AppStorage("user_name") var usernamestored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    @State var isLoading:Bool = false

    
    @State private var Title = ""
    @State var Content = ""
    @State var Venue  = ""
    @State var Category  = ""
    @State var VenueList = ["Malaysia","Singapore","Germany","Budhapest","Zurich","Telegram","Instagram"]
    @State var CateogoryList = ["Business","Technical","Cultural"]
 
    var body: some View {
        ZStack(){
            Color(red: 0.34, green: 0.39, blue: 0.94)
            
            VStack{
                HStack{
                   Spacer()
                    Button{dismiss()}label: {
                        RoundedRectangle(cornerRadius: 8, style: .circular)
                               .strokeBorder(.background) // Set the background color
                               .frame(width: 80, height: 30)
                               .overlay(
                                   Text("Dismiss")
                                       .foregroundColor(.white)
                                       .fontWeight(.bold)

                               )
                               .padding(.horizontal, 24)

                }
                }
                .offset(y:-50)
              
                    
                HStack(spacing: 6){
                    Text("Event on")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                  Text(EventDate)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        //.offset(y:5)
                        .font(.system(size: 34))
                        Spacer()
                }.padding(.horizontal,24)

                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .foregroundColor(.white) // Set the background color
                    .frame(height: 60) // Adjust the height of the RoundedRectangle

                    .overlay(
                        TextField("Title",text: $Title)
                            .foregroundColor(.black)
                            .padding(.horizontal,16)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom,14)
                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .foregroundColor(.white) // Set the background color
                    .frame(height: 60) // Adjust the height of the RoundedRectangle

                    .overlay(
                        HStack{
                            Text("From : ")
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(.leading)
                                .lineLimit(1)
                            DatePicker("", selection: $FromTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                            Spacer()
                                .frame(width: 1)
                            Text("To : ")
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(.leading)
                            DatePicker("", selection: $ToTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .padding(.trailing)
                        }
                        
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom,14)
                
                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .foregroundColor(.white) // Set the background color
                    .frame(height: 100) // Adjust the height of the RoundedRectangle

                    .overlay(
                        TextField("Description",text: $Content , axis: .vertical)
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
                        HStack{
                            Text("Venue: ")
                                .foregroundColor(.gray.opacity(0.7))
                                .padding()
                            Spacer()
                            Picker("Venue", selection: $Venue) {
                                ForEach(VenueList, id: \.self) { category in
                                    Text(category)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom,14)

                RoundedRectangle(cornerRadius: 12, style: .circular)
                    .foregroundColor(.white)
                    .frame(height: 60)
                    .overlay(
                        HStack{
                            Text("Category : ")
                                .foregroundColor(.gray.opacity(0.7))
                                .padding()
                            Spacer()
                            Picker("Category", selection: $Category) {
                                ForEach(CateogoryList, id: \.self) { category in
                                    Text(category)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 14)
                    .onTapGesture {
                        // Show the category picker here
                    }

              


                Button(action:{createPost()}, label: { RoundedRectangle(cornerRadius: 12, style: .circular)
                        .strokeBorder(.background) // Set the background color
                        .frame(height: 60)
                        .overlay(
                            Text("Book")
                                .foregroundColor(.white)
                                .fontWeight(.bold)

                        )
                        .padding(.horizontal, 24)


                }
                )

            }


        }.onAppear{dateConverter()}
            .overlay{
                
                    LoadingView(show: $isLoading)
                
            }
        .ignoresSafeArea()
        
        
        
    }
        
        func dateConverter() {
            
            if let selectedD = selectedDate {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let formattedDate = dateFormatter.string(from: selectedD)
                EventDate = formattedDate
                
            } else {
              EventDate = "Opps"
                
            }
        }
    
    func createPost(){
        isLoading = true
        //showkeyboard=false
        Task{
            do{
                //guard let profileURL = profileURL else { return }    ////////////////////URL  add when you are adding dp pic for every account //by ARAVIND RM
                
                let event = EventCard(title: Title, content: Content, venue: Venue, category: Category,publishdedDate: EventDate,fromtime: FromTime, totime: ToTime, userName: usernamestored, userUID: userUID)
                try await createDocumentAtFireBase(event)
                
            }
            
            
            catch{
                await setError(error)
            }
        }
        }
    
    
    func setError(_ error : Error) async{
        await MainActor.run(body:{
           let errorMessage = error.localizedDescription
            print(errorMessage)
        })
    }
    
    
    func createDocumentAtFireBase(_ event:EventCard) async throws{
        let doc = Firestore.firestore().collection("Events").document()
        let _ = try doc.setData(from: event, completion: {
            error in
            if error == nil{
                //isLoading = false

                dismiss()
            }else{
                //isLoading = false
                dismiss()

            }
        })
    }
    

}


struct AddEventsView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventsView()
    }
}
