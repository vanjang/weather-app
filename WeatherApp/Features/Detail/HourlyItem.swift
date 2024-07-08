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
        self.time = data.time
        self.desc = WeatherCodeConverter.convert(data.values.weatherCode)
        self.temperature = String(data.values.temperature)
    }
    
}
