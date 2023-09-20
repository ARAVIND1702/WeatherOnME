//
//  Events.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//

import SwiftUI
import FSCalendar
import Firebase

 
struct Events: View {
    @State private var date = Date()
    @State var fsCalendar = FSCalendar()
    @State var events: [EventCard] = []
    @State var eventName = ""
    @State private var selectedDate: Date?
    @State private var triggerForCover: Bool = false
    var body: some View {
        VStack{
            ZStack{
                HStack {
                    Button {
                        previousClicked()
                    } label: {
                     
                        Image("nav")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24,height: 24)
                    }
                    .padding(.all,4)
                     // Set the background color to black

                                Spacer()

                    Button {
                        nextClicked()
                        
                    } label: {
                     
                        Image("nav")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24,height: 24)
                            .rotationEffect(.degrees(180))


                    }
                    .padding(.all,4)

                            }
                .offset(y:-88)
                .background(RoundedRectangle(cornerRadius: 16,style: .continuous)
                    .fill(Color(red: 0.8980392156862745, green: 0.8980392156862745, blue: 0.8980392156862745))
                    .offset(y:-88)

                )
                            .padding(.horizontal, 8)
                CalendarViewRepresentable(calendar: $fsCalendar, selectedDate: $selectedDate) // Pass the binding to the selected date
                              .frame(width: 340, height: 227)
                              .onChange(of: selectedDate) { newValue in
                                                  // When selectedDate changes, set triggerForCover to true
                                                  triggerForCover = true
                                              }
            }
            
           
           
            
                    EventsListView()
            
          Spacer()
                        
                    
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.973, green: 0.972, blue: 0.981))
        .sheet(isPresented: $triggerForCover){
            AddEventsView(selectedDate: selectedDate)
            
        }
        .onAppear {
//            Task{
//                guard events.isEmpty else{ return }
//                await fetchEvents()
//            }
        }
        
    }
    
    
    func previousClicked() {
        let currentMonth = fsCalendar.currentPage
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? Date()
        fsCalendar.setCurrentPage(previousMonth, animated: true)
    }

    func nextClicked() {
        let currentMonth = fsCalendar.currentPage
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? Date()
        fsCalendar.setCurrentPage(nextMonth, animated: true)
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
                    
                })
            
        }catch{
            print(error)
            print("hi- error")
        }
    }
}


    


//struct CalendarViewRepresentable: UIViewRepresentable {
//    @Binding var calendar: FSCalendar
//
//    typealias UIViewType = FSCalendar
//    func makeUIView(context: Context) -> FSCalendar {
//        let calendar = FSCalendar()
//        calendar.delegate = context.coordinator
//        calendar.dataSource = context.coordinator
//
//        // Customize title text color for the calendar
//        calendar.appearance.titleDefaultColor = UIColor.black
//        calendar.appearance.headerSeparatorColor = UIColor.black
//        calendar.appearance.headerTitleColor = UIColor.black
//        calendar.appearance.titleFont = UIFont.boldSystemFont(ofSize: 12)
//
//        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 14) // Set bold font
//        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 14) // Set day names font to bold
//        calendar.appearance.weekdayTextColor = UIColor.gray // Set day names font to bold
//        calendar.appearance.todayColor = UIColor(red: 0.34, green: 0.39, blue: 0.94, alpha: 1.0)
//        calendar.appearance.borderRadius = 0.5
//        calendar.headerHeight = 50
//        calendar.appearance.headerMinimumDissolvedAlpha = 0.0;// Change this color as needed
//
//
//        calendar.calendarWeekdayView.weekdayLabels.forEach { $0.text = $0.text?.prefix(1).uppercased() }
//
//
//        return calendar
//    }
//
//    func updateUIView(_ uiView: FSCalendar, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
//        var parent: CalendarViewRepresentable
//
//        init(_ parent: CalendarViewRepresentable) {
//            self.parent = parent
//        }
//
//
//        // You can customize other appearance properties here if needed
//
//    }
//}


struct Events_Previews: PreviewProvider {
    static var previews: some View {
        Events()
    }
}
