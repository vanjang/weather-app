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
        var searchword: String
        var currentWeatherItem: CurrentWeatherItem?
        var hourlyItems: [HourlyItem]?
        var dailyItems: [DailyItem]?
        var recentHistoryItems: [DailyItem]?
        var errorMessage: String?
        var shouldShowAlert = false
        var isLoading: Bool = false
    }
    
    enum Action {
        case fetchCurrentWeather(searchword: String)
        case didFetchCurrentWeather(CurrentWeather)
        case fetchForecaset(searchword: String)
        case didFetchForecast(Forecast)
        case fetchRcentHistory(searchword: String)
        case didFetchRecentHistory(HistoryForecast)
        case setError(String)
        case setAlert(isPresented: Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchCurrentWeather(let searchword):
            state.isLoading = true
            return .run { send in
                let result = try await self.weatherClient.fetchCurrentWeather(searchword)
                
                switch result {
                case .success(let currentWeather):
                    await send(.didFetchCurrentWeather(currentWeather))
                case .failure(let error):
                    await send(.setError(error.localizedDescription))
                }
            }
        case .fetchForecaset(let searchword):
            state.isLoading = true
            return .run { send in
                let result = try await self.weatherClient.fetchForecast(searchword)
                
                switch result {
                case .success(let forecaset):
                    await send(.didFetchForecast(forecaset))
                case .failure(let error):
                    await send(.setError(error.localizedDescription))
                }
            }
        case .didFetchCurrentWeather(let currentWeather):
            state.isLoading = false
            state.currentWeatherItem = CurrentWeatherItem(currentWeather: currentWeather)
            return .none
        case .didFetchForecast(let forecast):
            state.hourlyItems = forecast.timelines.hourly.map { HourlyItem(data: $0) }
            state.dailyItems = forecast.timelines.daily.map { DailyItem(data: $0) }
            state.isLoading = false
            return .none
        case .fetchRcentHistory(let searchword):
            state.isLoading = true
            return .run { send in
                let result = try await self.weatherClient.fetchRecentHistory(searchword)
                
                switch result {
                case .success(let recentHistory):
                    await send(.didFetchRecentHistory(recentHistory))
                case .failure(let error):
                    await send(.setError(error.localizedDescription))
                }
            }
        case .didFetchRecentHistory(let recentHistory):
            state.isLoading = false
            state.recentHistoryItems = recentHistory.timelines.daily.map { DailyItem(data: $0, isHistoric: true) }
            return .none
        case .setError(let error):
            state.errorMessage = error
            state.isLoading = false
            return .run { send in
                await send(.setAlert(isPresented: true))
            }
        case .setAlert(isPresented: let isPresented):
            state.shouldShowAlert = isPresented
            return .none
        }
    }
    
}
