//
//  DailyItem.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import Foundation

struct DailyItem: Identifiable, Equatable {
    var id: UUID {
        UUID()
    }
    
    let day: String
    let desc: String
    let minTemperature: String
    let maxTemperature: String
    
    init(data: DailyWeatherData) {
        // TODO:
        self.day = "day"
        self.desc = WeatherCodeConverter.convert(data.values.weatherCodeMax)
        self.minTemperature = String(data.values.temperatureMin.rounded())
        self.maxTemperature = String(data.values.temperatureMax.rounded())
    }
}
