//
//  Forecast.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation

struct Forecast: Codable, Equatable {
    let timelines: Timelines
    let location: Location
}

extension Forecast {
    static let mock: Forecast = Forecast(timelines: Timelines(minutely: [], hourly: [], daily: []),
                                         location: Location(lat: 0.0, lon: 0.0, name: "", type: ""))
}
