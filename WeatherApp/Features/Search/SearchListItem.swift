//
//  SearchListItem.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import Foundation

struct SearchLocationListItem: Equatable, Identifiable {
    var id: UUID {
        UUID()
    }
    
    let locationName: String
    let searchKeyword: String
    let temperature: String
    let weatherDesc: String
    let upcomingForecastDesc: String
    
    init(currentWeather: CurrentWeather, forecast: Forecast, searchKeyword: String) {
        self.locationName = currentWeather.location.name
        self.searchKeyword = searchKeyword
        self.temperature = String(currentWeather.data.values.temperature)
        self.weatherDesc = WeatherCodeConverter.convert(currentWeather.data.values.weatherCode)
        self.upcomingForecastDesc = WeatherCodeConverter.convert(forecast.timelines.hourly.first?.values.weatherCode ?? 0)
    }
    
}

actor SearchLocationListItemContainer {
    var items = [SearchLocationListItem]()
    
    func append(_ item: SearchLocationListItem) {
        items.append(item)
    }
}
