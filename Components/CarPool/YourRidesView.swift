//
//  YourRidesView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 08/09/23.
//

import SwiftUI

struct YourRidesView: View {
    @State var Show = false
    var body: some View {
        VStack{
            if(Show == false){
               ReqList()
                Button{
                    
                    Show = true
                    
                    }label: {
                    Text("Create New Ride")
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 120)
                        .padding(.vertical,19)
                        .padding(.horizontal,100)
                        
                    
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color(red: 0.339, green: 0.396, blue: 0.95))
                                .shadow(color:.black.opacity(0.1) ,radius: 1 ,y:2)
                            
                        )
                }
            }
            else{
                    CreateNewRide(Show:$Show)
            }
      
            Spacer()
        }
       
        
        
    }
}

struct YourRidesView_Previews: PreviewProvider {
    static var previews: some View {
        YourRidesView()
    }
}
