//
//  Post.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct Post:Identifiable,Codable,Equatable,Hashable {
    @DocumentID var id: String?
    var text : String
    var imageURl:URL?
    var imageRefernceID: String = ""
    var publishdedDate: Date = Date()
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
    
//Basic info
    var userName :String
    var userUID :String
    var userProfileURL : URL?// add when you are adding dp pic for every account //by ARAVIND RM
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case imageURl // Corrected property name here
        case imageRefernceID
        case publishdedDate // Typo corrected, should be "publishedDate"
        case likedIDs
        case dislikedIDs
        case userName
        case userUID
        case userProfileURL  //URL  add when you are adding dp pic for every account //by ARAVIND RM
    }


    
}
