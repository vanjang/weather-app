//
//  City.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation

struct City: Equatable, Identifiable {
    var id: UUID {
        UUID()
    }
    
    var name: String {
        currentWeather.location.name
    }
    
    let currentWeather: CurrentWeather
    let forecast: Forecast
}

// An actor to safely manage a collection of City objects asynchronously.
actor CitiesContainer {
    var cities = [City]()
    
    func append(_ city: City) {
        cities.append(city)
    }
}
