//
//  ChartView.swift
//  AeroTrack_App
//
//  Created by Med Khalil Benkhelil on 11/6/24.
//

import SwiftUI
import Charts
import SwiftUICharts

struct ChartView: View {
    @State private var demoData: [Double] = []  // Data will be fetched from the API
    
    // Function to make the API call
    func fetchData() {
        // URL of your local chart API
        guard let url = URL(string: "http://192.168.1.2:3000/chart") else {
            print("Invalid URL")
            return
        }
        
        // Create a URL session to fetch the data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Decode the data into an array of Double
            do {
                let decodedData = try JSONDecoder().decode([Double].self, from: data)
                DispatchQueue.main.async {
                    self.demoData = decodedData  // Update the demoData state
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()  // Start the data task
    }
    
    var body: some View {
        VStack {
            if demoData.isEmpty {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    .scaleEffect(1.5)
                    .padding(.top, 50)
            } else {
                LineChartView(data: demoData, title: "Gaz CO2 Tracking", form: ChartForm.large, dropShadow: false)
            }
        }
        .padding()
        .onAppear(perform: fetchData)  // Fetch data when the view appears
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
