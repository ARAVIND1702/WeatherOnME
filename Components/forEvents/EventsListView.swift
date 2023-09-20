//
//  EventsListView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 04/09/23.
//

import SwiftUI
import Firebase
struct EventsListView: View {
    @State var events: [EventCard] = []
    @State var eventForSearch: [EventCard] = []

    @State var searchEvent :String = ""
    @State var isFetching: Bool = true

    var body: some View {
            LazyVStack{
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .foregroundColor(.white) // Set the background color
                    .frame( height: 42.09) // Adjust the height of the RoundedRectangle
                    .shadow(color:.black.opacity(0.1),radius: 3,y:4)
                    .overlay(HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray.opacity(0.4))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.leading)
                        TextField("Serach for event",text: $searchEvent)
                            .foregroundColor(.black)
                        Image("filter")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18,height: 22)
                            .padding()
                    }
                        
                    )
                    .padding(.horizontal)
                if isFetching{
                    ProgressView()
                        .padding(.top,30)
                }else{
                    if events.isEmpty{
                        ScrollView{
                            Text("No Events's Found")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top,30)
                        }
                        
                    }else{
                        
                        ScrollView(.vertical,showsIndicators: false){
                            Events()
                        }
                    }
                }
            }
        .refreshable {
            isFetching = true
            events = []
            await fetchEvents()
        }
        .task {
            guard events.isEmpty else{ return }
            await fetchEvents()
            
        }    }
    
    @ViewBuilder
    func Events()-> some View{
        VStack{

            ForEach(eventForSearch, id: \.id) { event in
                ReusableEventsCardView(event: event){
                    withAnimation(.easeInOut(duration: 0.35)){
                        events.removeAll{ event.id == $0.id}
                    }
                }
            }.onChange(of: searchEvent){newValue in
                    if !searchEvent.isEmpty{
                        eventForSearch = events.filter{ $0.title.contains(searchEvent)}
                    }
                    else{
                        eventForSearch = events
                    }
                }
            
        }
            
        
        
    }
    func fetchEvents()async{
        do{
            var query: Query!
            query = Firestore.firestore().collection("Events")
            
            
            let docs = try await query.getDocuments()
            let fetchedEvents = docs.documents.compactMap { doc -> EventCard? in
                try? doc.data(as: EventCard.self)
            }
                await MainActor.run(body: {
                    events = fetchedEvents
                    eventForSearch = fetchedEvents
                    isFetching = false
                })
            
        }catch{
            print(error)
            print("hi- error")
        }
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
    }
}
