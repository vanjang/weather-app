//
//  Timelines.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation

struct Timelines: Codable, Equatable {
    let minutely: [WeatherData]
    let hourly: [WeatherData]
    let daily: [WeatherData]
}
