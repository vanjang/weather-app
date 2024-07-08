//
//  WeatherData.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation

struct WeatherData: Codable, Equatable {
    let time: String
    let values: WeatherValues
}

struct DailyWeatherData: Codable, Equatable {
    let time: String
    let values: DailyWeatherValues
}
