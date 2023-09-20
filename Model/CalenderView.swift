//
//  CalenderView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 28/08/23.
//

import Foundation
import SwiftUI
import FSCalendar
import Firebase
struct CalendarViewRepresentable: UIViewRepresentable {
    @State var events: [EventCard] = []
    @Binding var calendar: FSCalendar
    @Binding var selectedDate: Date? // Add a @Binding property for the selected date
    
//    private var eventsBinding: Binding<[EventCard]> {
//            Binding {
//                events
//            } set: { newValue in
//                events = newValue
//                // Trigger a refresh of the calendar view when events change
//                calendar.reloadData()
//            }
//        }

    
    
    func makeUIView(context: Context) -> FSCalendar {
            calendar.delegate = context.coordinator
            calendar.dataSource = context.coordinator
    
            // Customize title text color for the calendar
            calendar.appearance.headerDateFormat = "MMMM, YYYY"
            calendar.appearance.titleDefaultColor = UIColor.black
            calendar.appearance.headerSeparatorColor = UIColor.black
            calendar.appearance.headerTitleColor = UIColor.black
            calendar.appearance.titleFont = UIFont.boldSystemFont(ofSize: 14)
    
            calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 14) // Set bold font
            calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16) // Set day names font to bold
            calendar.appearance.weekdayTextColor = UIColor.gray // Set day names font to bold
            calendar.appearance.todayColor = UIColor(red: 0.34, green: 0.39, blue: 0.94, alpha: 1.0)
            calendar.appearance.borderRadius = 0.3
            calendar.headerHeight = 50
            calendar.placeholderType = .none
            calendar.appearance.headerMinimumDissolvedAlpha = 0.0;// Change this color as needed
    
    
            calendar.calendarWeekdayView.weekdayLabels.forEach { $0.text = $0.text?.prefix(1).uppercased() }
    
    
            return calendar
        }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // Update any view-specific configurations if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
  

    
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarViewRepresentable
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "dd-MM-YYYY"
//                    let selectedDate = dateFormatter.string(from: date)
                    parent.selectedDate = date // Update the selectedDate binding
                    return
//                    print("Selected date: \(selectedDate)")
                }
        
        
        
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            var eventDates = [""]

            Task {
                do {
                    var query: Query!
                    query = Firestore.firestore().collection("Events")

                    let docs = try await query.getDocuments()
                    let fetchedEvents = docs.documents.compactMap { doc -> EventCard? in
                        try? doc.data(as: EventCard.self)
                    }
                    
                    await MainActor.run {
                        if(parent.events != fetchedEvents ){
                            parent.calendar.reloadData()
                        }

                        parent.events = fetchedEvents
                       // print(fetchedEvents.count)
                    }
                } catch {
                    print(error)
                    print("Error while fetching events: \(error.localizedDescription)")
                }
            }

            // To access the fetched events
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
         

            for event in parent.events {
//                  if let eventDate = dateFormatter.date(from: event.publishdedDate) {
//                      let eventDateStr = dateFormatter.string(from: eventDate)
//                      eventDates.append(eventDateStr)
//                  }
                
               
                eventDates.append(event.publishdedDate)
              }
            // Convert the array of event dates to Date objects
            let eventDateObjects = eventDates.compactMap { dateFormatter.date(from: $0) }
            
            // Check if the current date is in the array of event dates
            if eventDateObjects.contains(where: { $0.compare(date) == .orderedSame }) {
                return 1
            }
            
            return 0
        }

       
        // You can customize other appearance properties here if needed
    }
    

    
}


