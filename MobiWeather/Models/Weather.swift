//
//  Weather.swift
//  MobiWeather
//
//  Created by Adwitech on 07/05/21.
//  Copyright © 2021 techvedika. All rights reserved.
//

import Foundation

public struct WeatherReport: Decodable {
    // MARK: - Properties
    let city: String
    let address: String
    let lat: Double
    let lon: Double
}
