//
//  Values.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation

struct WeatherValues: Codable, Equatable {
//    let cloudBase: Double
//    let cloudCeiling: String
//    let cloudCover: Int
//    let dewPoint: Double
//    let freezingRainIntensity: Int
//    let humidity: Double
//    let precipitationProbability: Int
//    let pressureSurfaceLevel: Double
//    let rainIntensity: Double//int
//    let sleetIntensity: Int
//    let snowIntensity: Int
    let temperature: Double
//    let temperatureApparent: Double
//    let uvHealthConcern: Int
//    let uvIndex: Int
//    let visibility: Double//int
    let weatherCode: Int
//    let windDirection: Double
//    let windGust: Double//int
//    let windSpeed: Double
}

struct DailyWeatherValues: Codable, Equatable {
    let temperatureAvg: Double
    let temperatureMax: Double
    let temperatureMin: Double
    let weatherCodeMin: Int
    let weatherCodeMax: Int
}