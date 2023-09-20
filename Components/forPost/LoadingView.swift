//
//  LoadingView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 17/08/23.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show : Bool
    var body: some View {
        ZStack{
            if show{
                Group{
                    Rectangle()
                        .fill(.black.opacity(0.25))
                        .ignoresSafeArea()
                    ProgressView()
                        .padding(15)
                        .background(.white, in:RoundedRectangle(cornerRadius: 10 , style: .continuous))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: show)
    }
}
//
//struct LoadingView_Previews: PreviewProvider {
//    @Binding var showe = true
//    static var previews: some View {
//        LoadingView(show: showe)
//    }
//}
