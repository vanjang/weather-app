//
//  Location.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation

struct Location: Codable, Equatable {
    let lat: Double
    let lon: Double
    let name: String
    let type: String
}
