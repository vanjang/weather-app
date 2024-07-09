//
//  HistoryForecast.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import Foundation

struct HistoryForecast: Codable, Equatable {
    let timelines: HistoryTimelines
    let location: Location
}
