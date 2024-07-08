//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation

struct CurrentWeather: Codable, Equatable {
    let data: WeatherData
    let location: Location
}

