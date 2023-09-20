//
//  HistoryView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 14/09/23.
//

import SwiftUI

struct HistoryView: View {
    @AppStorage("user_UID") var userUID: String = ""

    var body: some View {
        otherRides(basedonUId: true,uid: userUID)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
