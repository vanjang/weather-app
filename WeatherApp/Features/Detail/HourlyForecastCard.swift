//
//  HourlyForecastCard.swift
//  WeatherApp
//
//  Created by myung hoon on 09/07/2024.
//

import SwiftUI

struct HourlyForecastCard: View {
    private let item: HourlyItem
    
    init(item: HourlyItem) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            Text(item.time)
                .font(.headline)
                .foregroundColor(.blue)
                .lineLimit(1)
            
            Text(item.desc)
                .font(.subheadline)
                .foregroundColor(.blue)
                .lineLimit(1)
            
            Text(item.temperature)
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(6)
    }
}

#Preview {
    let mocks = Mocks()
    return HourlyForecastCard(item: mocks.hourlyItems.first!)
}
