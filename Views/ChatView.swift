//
//  ChatView.swift
//  CommunityCloud
//
//  Created by GGS-BKS on 16/08/23.
//

import SwiftUI

struct ChatView: View {
    @State var messageText = ""
    @State var messages:[String] = ["Welcome to Office Buddy"]
    @State var formattedDate = ""

    var body: some View {
        ZStack{
            Color(red: 0.973, green: 0.972, blue: 0.981)
         //   Color(.blue)

        VStack{
            HStack{
                Text("Office Buddy")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
            ScrollView{
                ForEach(messages, id:\.self){ message in
                    if message.contains("[USER]"){
                        let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                        HStack{
                            Spacer()
                            ChatBalloon(newMessage: newMessage, formattedDate: formattedDate)
                            
                        }.padding(.horizontal)
                    
                 
                    }else{
                        HStack {
                            Text(message)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(10) // Apply corner radius to the RoundedRectangle background
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1) // Add the border to the RoundedRectangle
                                )
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            
                            Spacer()
                        }
                        .padding(.horizontal)

                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
            VStack{
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .foregroundColor(.white) // Set the background color
                    .frame(height: 120) // Adjust the height of the RoundedRectangle
                    .overlay(
                        VStack(alignment: .leading){
                            ScrollView{
                                HStack{
                                    Text(messageText.isEmpty ? "Ask anything" : "")
                                        .foregroundColor(.gray.opacity(0.4))
                                        .fontWeight(.heavy)
                                        .padding()
                                    Spacer()
                                }
                                TextField("",text: $messageText,axis: .vertical)
                                    .foregroundColor(.black)
                                    .padding(.horizontal,16)
                                    .onSubmit {
                                        sendMessage(message:messageText)
                                    }
                                
                            }
                        }
                     )
                
                  
                     // Add a black stroke with a line width of 1

                Button{
                
                        formatAndDisplayDate()
                        sendMessage(message: messageText)
                       
                } label: {
                    RoundedRectangle(cornerRadius: 12, style: .circular)
                        .frame(height: 60)
                        .overlay(
                            Text("Start Chat")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                        )
                        
                    
                    
                }
            }.padding(.horizontal,28)
                .padding(.bottom)
            
        }
        .frame(height: 700)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(width: 360)
            //.shadow(color:.black.opacity(0.1),radius: 4,y: 4)// Adjust the color and lineWidth as needed
        )
        .padding(.bottom,30)

        
            
        }
.ignoresSafeArea()

    }
    
    func sendMessage(message: String){
        withAnimation(.easeInOut(duration: 0.35)){
            messages.append("[USER]" + message)
            self.messageText = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            withAnimation(.easeInOut(duration: 0.35)){
                messages.append(getBotResponse(message: message))
            }
        }
    }
    
    //--for toime of message sent --//
     func formatAndDisplayDate()  {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm"

            let currentDate = Date() // Get the current date
            formattedDate = dateFormatter.string(from: currentDate)
            print(formattedDate)
        }


}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

//Color(red: 0.973, green: 0.972, blue: 0.981)
