//
//  CustomTabView.swift
//  TestProject0105
//
//  Created by GGS-BKS on 23/08/23.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabItems:[(image:String,title:String)] = [
        ("house.fill","Home"),
        ("calendar","Events"),
        ("message.fill","Office Buddy"),
        ("car.fill","Car Pool"),
        ("person.fill","My profile")


    ]
    var body: some View {
//        ZStack{
//            Rectangle()
//                .fill(Color(hue: 1.0, saturation: 0.0, brightness: 0.851))
//                .frame(height: 78)
            HStack(spacing:5){
                ForEach(0..<5){ index in
                    Button{
                        tabSelection = index + 1
                    } label: {
                        ZStack{
                            if index + 1 == tabSelection {
                                RoundedRectangle(cornerRadius: 10,style: .continuous)
                                    .shadow(radius: 4)
                                    .frame(width:60,height: 57)
                                    .offset(y:20)
                                    
                            }
                            VStack(spacing: 5){
                                Spacer()
                                Image(systemName: tabItems[index].image)
                                    .font(.title3)
                                Text(tabItems[index].title)
                                    .font(.system(size: 9))
                                    .frame(width: 70)
                                
                            }.foregroundColor(index + 1 == tabSelection ? .white : .gray)
                                .offset(y:5)

                            
                        }
                    }
                }
            }.frame(height: 70)
             .padding(.horizontal)
            
//        }
    }
}
struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(tabSelection: .constant(1))
            
    }
}
