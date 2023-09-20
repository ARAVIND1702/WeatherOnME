//
//  CommunityCloudApp.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 14/08/23.
//

import SwiftUI
import Firebase

@main
struct CommunityCloudApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
