//
//  Values.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation

struct WeatherValues: Codable, Equatable {
    let temperature: Double?
    let weatherCode: Int?
}

struct DailyWeatherValues: Codable, Equatable {
    let temperatureAvg: Double?
    let temperatureMax: Double?
    let temperatureMin: Double?
    let weatherCodeMin: Int?
    let weatherCodeMax: Int?
}
