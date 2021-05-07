//
//  NetworkManager.swift
//  MobiWeather
//
//  Created by Adwitech on 07/05/21.
//  Copyright © 2021 techvedika. All rights reserved.
//

import Foundation

import UIKit

class MbNetworkManager {
    
    static let shared = MbNetworkManager()
    
    func makeGetRequest(coordinates: (Double, Double), handler: @escaping (_ result: [String: Any]?, _ error: Error?)->Void) {
        let session = URLSession.shared
        let urlString = Constants.BASE_URL + "?lat=\(coordinates.0)&lon=\(coordinates.1)&appid=\(Constants.API_KEY)&units=metric"
        //now create the URLRequest object using the url object
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                handler(nil, error)
                return
            }

            guard let data = data else {
                handler(nil, error)
                return
            }

           do {
              //create json object from data
              if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                handler(json, nil)
              }
           } catch let error {
             print(error.localizedDescription)
           }
        })

        task.resume()
    }

}

