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
    @Dependency(\.weatherClient) var weatherClient
    
    @ObservableState
    struct State: Equatable {
        var listItems: [SearchLocationListItem]?
        var selectedListItem: SearchLocationListItem?
        var searchKeyword: String = ""
        var errorMessage: String?
        var shouldShowDetailPage = false
        var shouldShowAlert = false
        var isLoading: Bool = false
    }
    
    enum Action: Equatable {
        case currentSearchKeyword(String)
        case fetchItems(keywords: [String])
        case fetchedItems([SearchLocationListItem])
        case saveKeyword(String)
        case getPreviousSearchHistory
        case setDetailPage(isPresented: Bool)
        case setSelectedItem(SearchLocationListItem)
        case setError(String)
        case setAlert(isPresented: Bool)
    }
    
    private let localSavingKey = "searchKeywords"
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .currentSearchKeyword(let searchKeyword):
            state.searchKeyword = searchKeyword
            
            if searchKeyword.isEmpty {
                return .send(.getPreviousSearchHistory)
            } else {
                return .none
            }
        case .fetchItems(let keywords):
            state.isLoading = true
            return .run { send in
                let container = SearchLocationListItemContainer()
                
                await withTaskGroup(of: Void.self) { taskGroup in
                    for keyword in keywords {
                        taskGroup.addTask {
                            do {
                                let currentWeatherResult = try await self.weatherClient.fetchCurrentWeather(keyword)
                                let forecasetResult = try await self.weatherClient.fetchForecast(keyword)
                                
                                var currentWeather: CurrentWeather?
                                var forecast: Forecast?
                                
                                switch currentWeatherResult {
                                case .success(let w): currentWeather = w
                                case .failure(let error): await send(.setError(error.localizedDescription))
                                }
                                
                                switch forecasetResult {
                                case .success(let f): forecast = f
                                case .failure(let error): await send(.setError(error.localizedDescription))
                                }
                                
                                if let c = currentWeather, let f = forecast {
                                    let listItem = SearchLocationListItem(currentWeather: c, forecast: f, searchKeyword: keyword)
                                    await container.append(listItem)
                                } else {
                                    await send(.setError("Unknown error occurred."))
                                }
                            } catch {
                                print("Decoding error: \(error)")
                                await send(.setError(error.localizedDescription))
                            }
                        }
                    }
                }
                
                let items = await container.items
                await send(.fetchedItems(items))
            }
        case .fetchedItems(let items):
            state.listItems = items
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
            var keywords = [keyword]
            
            if let searchKeywords = UserDefaults.standard.array(forKey: localSavingKey) as? [String], !searchKeywords.contains(keyword) {
                keywords += searchKeywords
            }
            
            UserDefaults.standard.set(Array(Set(keywords)), forKey: localSavingKey)
            
            return .none
        case .getPreviousSearchHistory:
            let searchKeywords = UserDefaults.standard.array(forKey: localSavingKey) as? [String] ?? []
            
            return .run { send in
                await send(.fetchItems(keywords: searchKeywords))
            }
        case .setError(let error):
            state.errorMessage = error
            state.isLoading = false
            return .run { send in
                await send(.setAlert(isPresented: true))
            }
        case .setDetailPage(let isPresented):
            state.shouldShowDetailPage = isPresented
            return .none
        case .setSelectedItem(let item):
            state.selectedListItem = item
            return .none
        case .setAlert(let isPresented):
            state.shouldShowAlert = isPresented
            return .none
        }
    }
    
}
