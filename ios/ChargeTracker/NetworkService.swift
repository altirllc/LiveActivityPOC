//
//  NetworkService.swift
//  LiveActivityPOC
//
//  Created by Varun Kukade on 26/11/24.
//

import Foundation
import ActivityKit

class NetworkService {
 static func callAPI(url: String, httpMethod: String, httpBody: Data, authToken: String) {
  
   //create URL
   guard let url = URL(string: url) else {
           print("Invalid URL")
           return
   }
  
    // Create a URLRequest object
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.httpBody = httpBody
  
    // Add headers
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
  
     // Create a URLSession data task
     let task = URLSession.shared.dataTask(with: request) { data, response, error in
         // Check for errors
         if let error = error {
             print("Error making API call: \(error)")
             return
         }
        
         // Check response status and handle data
         if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
             // Ensure there's data to work with
             guard let data = data else {
                 print("No data received")
                 return
             }
           print("data:", data)
         } else {
             print("Invalid response or status code")
         }
     }
       // Start the data task
       task.resume()
 }
}
