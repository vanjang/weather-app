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
    let avgTemperature: String
    let temperature: String
    
    init(data: DailyWeatherData, isHistoric: Bool = false) {
        self.day = isHistoric ? DateConverter.getDateString(from: data.time, type: .dayMonth) : DateConverter.getDateString(from: data.time, type: .weekday)
        let minDesc = WeatherCodeConverter.convert(data.values.weatherCodeMin ?? 0)
        let maxDesc = WeatherCodeConverter.convert(data.values.weatherCodeMax ?? 0)
        self.desc = "\(minDesc) / \(maxDesc)"
        let avgTemperature = String(data.values.temperatureAvg?.rounded() ?? 0)
        self.avgTemperature = "avg \(avgTemperature)°"
        
        let minTemperature = String(data.values.temperatureMin?.rounded() ?? 0)
        let maxTemperature = String(data.values.temperatureMax?.rounded() ?? 0)
        self.temperature = "\(minTemperature)°/\(maxTemperature)°"
    }
}
