//
//  EventCard.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 28/08/23.
//


import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct EventCard:Identifiable,Codable,Equatable,Hashable {
    @DocumentID var id: String?
//    var id = UUID() // This should be a unique identifier for each event
    var title : String
    var content : String
    var venue : String
    var category : String
    var publishdedDate: String
    var fromtime:Date = Date()
    var totime:Date = Date()
    var accepted: [String] = []
//    var dislikedIDs: [String] = []
    
//Basic info
    var userName :String
    var userUID :String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case venue // Corrected property name here
        case category
        case publishdedDate // Typo corrected, should be "publishedDate"
        case accepted
        case fromtime
        case totime
        case userName
        case userUID
        //URL  add when you are adding dp pic for every account //by ARAVIND RM
    }


    
}
