//
//  EventCard.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 28/08/23.
//


import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct CarPool:Identifiable,Codable,Equatable,Hashable {
    @DocumentID var id: String?
//    var id = UUID() // This should be a unique identifier for each event
    var CurrentLocation : String
    var DropLocation : String
    var OnDateofTravel:Date = Date()
    var NoofSeats: Int
    var Joined: [String] = []
    var Waiting: [String] = []

    var userProfileURL : URL?// add when you are adding dp pic for every account //by ARAVIND RM
//    var dislikedIDs: [String] = []
    
//Basic info
    var userName :String
    var userUID :String
    
    enum CodingKeys: String, CodingKey {
        case id
        case CurrentLocation
        case DropLocation
        case OnDateofTravel
        case NoofSeats
        case Joined // Typo corrected, should be "publishedDate"
        case Waiting
        case userName
        case userUID
        case userProfileURL
        //URL  add when you are adding dp pic for every account //by ARAVIND RM
    }


    
}
