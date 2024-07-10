//
//  SearchCard.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import SwiftUI

struct SearchCard: View {
    private let item: SearchListItem
    
    init(item: SearchListItem) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(item.locationName)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                
                Spacer()
                
                Text(item.weatherDesc)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
            }
            
            HStack {
                Text(item.temperature)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                
                Spacer()
                
                Text(item.upcomingForecastDesc)
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
    let mocks = Mocks()
    return SearchCard(item: mocks.searchListItem)
}
