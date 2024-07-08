//
//  HourlyItem.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import Foundation

struct HourlyItem: Identifiable, Equatable {
    var id: UUID {
        UUID()
    }
    
    let time: String
    let desc: String
    let temperature: String
    
    init(data: WeatherData) {
        self.time = DateConverter.getDateString(from: data.time, type: .time)
        self.desc = WeatherCodeConverter.convert(data.values.weatherCode ?? 0)
        self.temperature = "\(String(data.values.temperature?.rounded() ?? 0))°"
    }
    
}
