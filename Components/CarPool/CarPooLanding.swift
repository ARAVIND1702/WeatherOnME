//
//  CarPooLanding.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 07/09/23.
//

import SwiftUI

struct CarPooLanding: View {
    @State var active = 1
    var body: some View {
        VStack{
            HStack{
                Button{  withAnimation(.easeInOut(duration: 0.35)) {
                    active = 1
                }
                    
                }label: {
                    Text("Other Rides")
                        .font(.system(size: 14).bold())
                        .padding(.horizontal)
                        .padding(.vertical,8)
                        .foregroundColor(active == 1 ? .accentColor : .gray)
                        .overlay(
                                    Capsule()
                                        .stroke()
                                        .opacity(active == 1 ? 1.0 : 0.0) // Initially, set opacity to 0, and animate to 1 when active is 1
                                     //   .animation(.easeInOut(duration: 0.45)) // Add animation to the opacity change
                                )
                        
                }
                Button{ withAnimation(.easeInOut(duration: 0.35)) {
                    active = 2
                } }label: {
                    Text("Your Rides")
                        .font(.system(size: 14).bold())
                        .padding(.horizontal)
                        .padding(.vertical,8)
                        .foregroundColor(active == 2 ? .accentColor : .gray)
                        .overlay(
                            active == 2 ? Capsule().stroke() : nil
                        )
                     
                        
                }
                Button{ withAnimation(.easeInOut(duration: 0.35)) {
                    active = 3
                }}label: {
                    Text("History")
                        .font(.system(size: 14).bold())
                        .padding(.horizontal)
                        .padding(.vertical,8)
                        .foregroundColor(active == 3 ? .accentColor : .gray)
                        .overlay(
                            active == 3 ? Capsule().stroke() : nil
                        )
                     
                        
                }
            }
            .padding(.vertical)
            .padding(.horizontal,4)
        
                if active == 1 {
                    otherRides()
                }
                else if (active == 2) {
                        YourRidesView()
                    }
                else if (active == 3) {
                    HistoryView()
                }

                

            
            
        }.background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 360)
                //.shadow(color:.black.opacity(0.1),radius: 4,y: 4)// Adjust the color and lineWidth as needed
        )
        .padding()
    }
}

struct CarPooLanding_Previews: PreviewProvider {
    static var previews: some View {
        CarPooLanding()
    }
}
