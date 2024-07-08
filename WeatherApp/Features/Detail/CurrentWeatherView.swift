//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import SwiftUI

struct CurrentWeatherView: View {
    let locationName: String
    let temperature: String
    let desc: String
    
    init(item: CurrentWeatherItem) {
        self.locationName = item.locationName
        self.temperature = item.temperature + "°"
        self.desc = item.desc
    }
    
    var body: some View {
        VStack {
            Text(locationName)
                .font(.title)
                .foregroundColor(.blue)
                .lineLimit(2)
            
            Text(temperature)
                .font(.headline)
                .foregroundColor(.blue)
                .lineLimit(1)
            
            Text(desc)
                .font(.headline)
                .foregroundColor(.blue)
                .lineLimit(1)
        }
        .padding(35)
    }
}

#Preview {
    CurrentWeatherView(item: CurrentWeatherItem(currentWeather: CurrentWeather(data: WeatherData(time: "", values: WeatherValues(temperature: 0, weatherCode: 0)),
                                                                               location: Location(lat: 0, lon: 0, name: "", type: ""))))
}
