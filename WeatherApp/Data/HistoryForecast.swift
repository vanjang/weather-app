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

extension HistoryForecast {
    static let mock: HistoryForecast = HistoryForecast(timelines: HistoryTimelines(hourly: [], daily: []),
                                                       location: Location(lat: 0.0, lon: 0.0, name: "", type: ""))
}
