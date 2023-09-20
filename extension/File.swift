//
//  File.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//

import Foundation
 import SwiftUI

extension View{
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
 
}


