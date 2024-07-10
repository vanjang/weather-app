//
//  DailyForecastCard.swift
//  WeatherApp
//
//  Created by myung hoon on 09/07/2024.
//

import SwiftUI

struct DailyForecastCard: View {
    private let item: DailyItem
    
    init(item: DailyItem) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            Text(item.day)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blue)
            
            Text(item.desc)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.blue)
            
            HStack {
                Text(item.temperature)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text(item.avgTemperature)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

#Preview {
    let mocks = Mocks()
    return DailyForecastCard(item: mocks.dailyItems.first!)
}
