//
//  SearchReducer.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchReducer {
    @Dependency(\.searchClient) var searchClient
    
    @ObservableState
    struct State: Equatable {
        var cities: [City]?
        var searchKeyword: String = ""
        var errorMessage: String?
        var isLoading: Bool = false
    }
    
    enum Action: Equatable {
        case currentSearchKeyword(String)
        case fetchCities(keywords: [String])
        case fetchedCities([City])
        case saveKeyword(String)
        case getPreviousSearchHistory
        case setError(String)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .currentSearchKeyword(let searchKeyword):
            state.searchKeyword = searchKeyword
            print(state.searchKeyword)
            return .none
        case .fetchCities(let keywords):
            state.isLoading = true
            return .run { send in
                let citiesContainer = CitiesContainer()
                
                await withTaskGroup(of: Void.self) { taskGroup in
                    for keyword in keywords {
                        taskGroup.addTask {
                            do {
                                let currentWeather = try await self.searchClient.fetchCurrentWeathers(keyword)
                                let forecast = try await self.searchClient.fetchForecast(keyword)
                                let city = City(currentWeather: currentWeather, forecast: forecast)
                                await citiesContainer.append(city)
                            } catch {
                                print("Decoding error: \(error)")
                                await send(.setError(error.localizedDescription))

                            }
                        }
                    }
                }
                
                let cities = await citiesContainer.cities
                await send(.fetchedCities(cities))
            }
        case .fetchedCities(cities: let cities):
            state.cities = cities
            state.errorMessage = nil
            state.isLoading = false
            let keyword = state.searchKeyword
            
            if keyword.isEmpty {
                return .none
            } else {
                return .run { send in
                    await send(.saveKeyword(keyword))
                }
            }
        case .saveKeyword(let keyword):
            let key = "searchKeywords"
            var keywords = [keyword]
            
            if let searchKeywords = UserDefaults.standard.array(forKey: key) as? [String], !searchKeywords.contains(keyword) {
                keywords += searchKeywords
            }
            
            UserDefaults.standard.set(Array(Set(keywords)), forKey: key)
            
            return .none
        case .getPreviousSearchHistory:
            let key = "searchKeywords"
            let searchKeywords = UserDefaults.standard.array(forKey: key) as? [String] ?? []
            
            return .run { send in
                await send(.fetchCities(keywords: searchKeywords))
            }
        case .setError(let error):
            state.errorMessage = error
            state.isLoading = false
            return .none
        }
    }
    
}
