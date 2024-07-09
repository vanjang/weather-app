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
