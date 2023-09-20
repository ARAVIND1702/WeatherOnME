import SwiftUI
import MapKit
import FirebaseFirestoreSwift
import FirebaseStorage
import Firebase

struct CreateNewRide: View {
    @Binding var Show: Bool
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default location (San Francisco)
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Default zoom level
    )
    
    @State var Seats = [1,2,3,4]
    @State var Seat  = 1
    
    @State private var date = Date()
    let dateRange: ClosedRange<Date> = {
         let calendar = Calendar.current
         let today = calendar.startOfDay(for: Date())
         let endComponents = DateComponents(year: 2023, month: 12, day: 31, hour: 23, minute: 59, second: 59)
         return today ... calendar.date(from: endComponents)!
     }()

    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("log_status") var userIsLoggedIn:Bool = false
    @AppStorage("user_name") var usernamestored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    @State private var Currentlocation = "" // State variable to store location name
    @State private var Droplocation = "" // State variable to store location name

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .foregroundColor(.white) // Set the background color
                .frame(height: 40) // Adjust the height of the RoundedRectangle
                .overlay(
                    HStack{
                        Circle()
                            .fill(.green)
                            .frame(width: 10)
                            .padding(.leading)
                        TextField("", text: $Currentlocation, prompt: Text("Your current location").foregroundColor(.black))
                            .foregroundColor(.black)
                            .onChange(of: Currentlocation){ newValue in
                                let geocoder = CLGeocoder()
                                geocoder.geocodeAddressString(Currentlocation) { placemarks, error in
                                    if let placemark = placemarks?.first, let location = placemark.location {
                                        region.center = location.coordinate
                                        region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                    }
                                }
                            }
                    }
                )
                .padding(.bottom,12)
                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)
             
            Map(coordinateRegion: $region)
                .frame(height: 180)
            
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .foregroundColor(.white) // Set the background color
                .frame(height: 40) // Adjust the height of the RoundedRectangle
                .overlay(
                    HStack{
                        Circle()
                            .fill(.red)
                            .frame(width: 10)
                            .padding(.leading)
                        TextField("", text: $Droplocation, prompt: Text("Enter drop Location").foregroundColor(.black))
                            

                    }
                )
                .padding(.top,12)
                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .foregroundColor(.white) // Set the background color
                .frame(height: 40) // Adjust the height of the RoundedRectangle
                .overlay(
                    HStack{
                      
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                            .padding(.leading)
                        DatePicker(
                                "",
                                 selection: $date,
                                 in: dateRange,
                                 displayedComponents: [.date, .hourAndMinute]
                                    
                            )

                        .padding(.trailing,20)
//                        TextField("Select Date and Time",text: $locationName)
//                            .foregroundColor(.black)
//                            .padding(.horizontal,16)
                    }
                )
                .padding(.top,12)
                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .foregroundColor(.white)
                .frame(height: 40)
                .overlay(
                    HStack{
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                            .padding(.leading)
                        Text("No of seats available")
                            .foregroundColor(.gray.opacity(0.7))
                            .padding()
                        Spacer()
                        Picker("Seats", selection: $Seat) {
                            ForEach(Seats, id: \.self) { seat in
                                Text(String(seat))
                            }
                        }
                        .foregroundColor(.black)
                        .pickerStyle(.menu)
                        .tint(.black)
                        .onAppear {
                            // Change the appearance of the Picker
                            UITableView.appearance().separatorColor = .clear // Hides separators
                            UITableViewCell.appearance().tintColor = .black // Set the chevron color to black
                        }


                    }
                    
                )
                .padding(.top, 12)
                .shadow(color:.black.opacity(0.1) ,radius: 2 ,y:2)

            Button{
//                let geocoder = CLGeocoder()
//                geocoder.geocodeAddressString(Currentlocation) { placemarks, error in
//                    if let placemark = placemarks?.first, let location = placemark.location {
//                        region.center = location.coordinate
//                        region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//                    }
//                }
                createPool()
                }label: {
                Text("Save")
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 160)
                    .padding(.vertical,19)
                    .padding(.horizontal,90)
                    .background(
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color(red: 0.339, green: 0.396, blue: 0.95))
                            .shadow(color:.black.opacity(0.1) ,radius: 1 ,y:2)
                        
                    )
                }.padding(.top,12)
            
        }
    }
    
    func createPool(){
//        isLoading = true
        //showkeyboard=false
        Task{
            do{
                //guard let profileURL = profileURL else { return }    ////////////////////URL  add when you are adding dp pic for every account //by ARAVIND RM
                
                let carpool = CarPool(CurrentLocation: Currentlocation, DropLocation: Droplocation, NoofSeats: Seat, userProfileURL: profileURL ?? URL(string: "ASDasdas")!, userName: usernamestored, userUID: userUID)
                try await createDocumentAtFireBase(carpool)
                
            }
            
            
            catch{
                await setError(error)
            }
        }
        }
    
    
    func setError(_ error : Error) async{
        await MainActor.run(body:{
           let errorMessage = error.localizedDescription
            print(errorMessage)
        })
    }
    
    
    func createDocumentAtFireBase(_ carpool:CarPool) async throws{
        let doc = Firestore.firestore().collection("CarPools").document()
        let _ = try doc.setData(from: carpool, completion: {
            error in
            if error == nil{
                //isLoading = false

                Show = false
            }else{
                //isLoading = false
                Show = false

            }
        })
    }
    

}



//struct CreateNewRide_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNewRide()
//    }
//}
