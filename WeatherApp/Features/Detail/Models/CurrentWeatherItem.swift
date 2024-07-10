//
//  CurrentWeatherItem.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import Foundation

struct CurrentWeatherItem: Equatable {
    let locationName: String
    let desc: String
    let temperature: String
    
    init(currentWeather: CurrentWeather) {
        self.locationName = currentWeather.location.name
        self.desc = WeatherCodeConverter.convert(currentWeather.data.values.weatherCode ?? 0)
        self.temperature = "\(String(currentWeather.data.values.temperature ?? 0))°"
    }
}
