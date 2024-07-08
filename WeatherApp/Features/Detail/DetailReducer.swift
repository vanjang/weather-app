//
//  DetailReducer.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailReducer {
    @Dependency(\.weatherClient) var weatherClient
    
    @ObservableState
    struct State: Equatable {
        var searchKeyword: String
        var currentWeatherItem: CurrentWeatherItem?
        var hourlyItems: [HourlyItem]?
        var dailyItems: [DailyItem]?
        var recentHistoryItems: [DailyItem]?
        var errorMessage: String?
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchCurrentWeather(keyword: String)
        case fetchForecaset(keyword: String)
        case fetchedCurrentWeather(CurrentWeather)
        case fetchedForecast(Forecast)
        case fetchRcentHistory(keyword: String)
        case fetchedRecentHistory(HistoryForecast)
        case setError(String)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchCurrentWeather(let keyword):
            state.isLoading = true
            return .run { send in
                let currentWeather = try await self.weatherClient.fetchCurrentWeather(keyword)
                await send(.fetchedCurrentWeather(currentWeather))
            }
        case .fetchForecaset(keyword: let keyword):
            state.isLoading = true
            return .run { send in
                let forecast = try await self.weatherClient.fetchForecast(keyword)
                await send(.fetchedForecast(forecast))
            }
        case .fetchedCurrentWeather(let currentWeather):
            state.isLoading = false
            state.currentWeatherItem = CurrentWeatherItem(currentWeather: currentWeather)
            return .none
        case .fetchedForecast(let forecast):
            state.hourlyItems = forecast.timelines.hourly.map { HourlyItem(data: $0) }
            state.dailyItems = forecast.timelines.daily.map { DailyItem(data: $0) }
            state.isLoading = false
            return .none
        case .fetchRcentHistory(let keyword):
            state.isLoading = true
            return .run { send in
                let recentHistory = try await self.weatherClient.fetchRecentHistory(keyword)
                await send(.fetchedRecentHistory(recentHistory))
            }
        case .fetchedRecentHistory(let recentHistory):
            state.isLoading = false
            state.recentHistoryItems = recentHistory.timelines.daily.map { DailyItem(data: $0) }
            return .none
        case .setError(let error):
            state.errorMessage = error
            return .none
        }
    }
    
}
