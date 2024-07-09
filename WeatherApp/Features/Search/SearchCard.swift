//
//  SearchCard.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import SwiftUI

struct SearchCard: View {
    let locationName: String
    let currentWeather: String
    let temperature: String
    let forecast: String
    
    init(item: SearchListItem) {
        self.locationName = item.locationName
        self.currentWeather = item.weatherDesc
        self.temperature = item.temperature + "°"
        self.forecast = item.upcomingForecastDesc
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(locationName)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                                  
                Spacer()
                
                Text(currentWeather)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
            
            HStack {
                Text(temperature)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                
                Spacer()
                
                Text(forecast)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
         .padding(12)
         .background(Color.white)
         .cornerRadius(10)
         .shadow(radius: 3)
     }
}

#Preview {
    SearchCard(item: SearchListItem(currentWeather: CurrentWeather(data: WeatherData(time: "", values: WeatherValues(temperature: 0, weatherCode: 0)), location: Location(lat: 0, lon: 0, name: "", type: "")), forecast: Forecast(timelines: Timelines(minutely: [], hourly: [], daily: []), location: Location(lat: 0, lon: 0, name: "", type: "")), searchKeyword: ""))
}
