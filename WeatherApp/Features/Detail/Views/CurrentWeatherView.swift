//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import SwiftUI

struct CurrentWeatherView: View {
    private let item: CurrentWeatherItem
    
    init(item: CurrentWeatherItem) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            Text(item.locationName)
                .font(.title)
                .foregroundColor(.blue)
                .lineLimit(2)
            
            Text(item.temperature)
                .font(.headline)
                .foregroundColor(.blue)
                .lineLimit(1)
            
            Text(item.desc)
                .font(.headline)
                .foregroundColor(.blue)
                .lineLimit(1)
        }
        .padding(35)
    }
}

#Preview {
    let mocks = Mocks()
    return CurrentWeatherView(item: CurrentWeatherItem(currentWeather: mocks.currentWeather))
}
