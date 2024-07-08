//
//  HistoryTimelines.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import Foundation

struct HistoryTimelines: Codable, Equatable {
    let hourly: [WeatherData]
    let daily: [DailyWeatherData]
}
