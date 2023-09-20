//
//  User.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//
import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var userBio: String
    var userBioLink: String?
    var userUID: String  // Fixed typo here
    var userEmail: String
   var userProfileURL: URL?
    
    enum CodingKeys: String, CodingKey { // Specify CodingKeys as String
        case id
        case username
        case userBio
        case userBioLink
        case userUID // Fixed typo here
        case userEmail
        case userProfileURL
    }
}
