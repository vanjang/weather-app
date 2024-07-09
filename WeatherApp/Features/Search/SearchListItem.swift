//
//  SearchListItem.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import Foundation

struct SearchListItem: Equatable, Identifiable {
    var id: UUID {
        UUID()
    }
    
    let locationName: String
    let searchword: String
    let temperature: String
    let weatherDesc: String
    let upcomingForecastDesc: String
    
    init(currentWeather: CurrentWeather, forecast: Forecast, searchword: String) {
        self.locationName = currentWeather.location.name
        self.searchword = searchword
        self.temperature = "\(String(currentWeather.data.values.temperature?.rounded() ?? 0))°"
        self.weatherDesc = WeatherCodeConverter.convert(currentWeather.data.values.weatherCode ?? 0)
        self.upcomingForecastDesc = "then: \(WeatherCodeConverter.convert(forecast.timelines.hourly.first?.values.weatherCode ?? 0))"
    }
}

actor SearchListContainer {
    var items = [SearchListItem]()
    
    func append(_ item: SearchListItem) {
        items.append(item)
    }
}
