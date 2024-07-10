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
        var listItems: [SearchListItem]?
        var selectedListItem: SearchListItem?
        var searchword: String = ""
        var errorMessage: String?
        var shouldShowDetailPage = false
        var shouldShowAlert = false
        var isLoading: Bool = false
    }
    
    enum Action: Equatable {
        case fetchSearchHistory
        case didSearchwordChanged(String)
        case fetchItems(searchwords: [String])
        case didFetchItems([SearchListItem])
        case saveSearchword(String)
        case setDetailPage(isPresented: Bool)
        case setSelectedItem(SearchListItem)
        case setError(String)
        case setAlert(isPresented: Bool)
    }
    
    private let localSavingKey = "searchwords"
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didSearchwordChanged(let searchword):
            let lastSearchword = state.searchword
            state.searchword = searchword
            let currentSearchword = state.searchword
            
            let searchwordClearedFromKeyboard = currentSearchword.isEmpty && !lastSearchword.isEmpty
            
            // Only fetch when user deleted searchword entiely in order to prevent unnecessary API calls.
            if searchwordClearedFromKeyboard {
                return .send(.fetchSearchHistory)
            } else {
                return .none
            }
        case .fetchItems(let searchwords):
            state.isLoading = true
            return .run { send in
                let items = try await fetchWeatherData(forSearchwords: searchwords, weatherClient: self.weatherClient)
                await send(.didFetchItems(items))
            }
        case .didFetchItems(let items):
            state.listItems = items
            state.isLoading = false
            let searchword = state.searchword
            
            // Searchword being empty means the fetch used the stored searchword, therefore no need to save searchword.
            if searchword.isEmpty {
                return .none
            } else {
                return .run { send in
                    await send(.saveSearchword(searchword))
                }
            }
        case .saveSearchword(let searchword):
            var searchwords = [searchword]
            
            // Save searchword if not duplicated.
            if let savedSearchwords = UserDefaults.standard.array(forKey: localSavingKey) as? [String], !savedSearchwords.contains(searchword) {
                searchwords += savedSearchwords
            }
            
            UserDefaults.standard.set(Array(Set(searchwords)), forKey: localSavingKey)
            
            return .none
        case .fetchSearchHistory:
            let searchwords = UserDefaults.standard.array(forKey: localSavingKey) as? [String] ?? []
            
            return .run { send in
                await send(.fetchItems(searchwords: searchwords))
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
    
    /// A throwable function handling multiple async works in task group.
    func fetchWeatherData(forSearchwords searchwords: [String], weatherClient: WeatherClient) async throws -> [SearchListItem] {
        let container = SearchListContainer()

        await withThrowingTaskGroup(of: Void.self) { taskGroup in
            for searchword in searchwords {
                taskGroup.addTask {
                    do {
                        async let currentWeather = weatherClient.fetchCurrentWeather(searchword)
                        async let forecast = weatherClient.fetchForecast(searchword)

                        let (currentWeatherResult, forecastResult) = try await (currentWeather, forecast)

                        switch (currentWeatherResult, forecastResult) {
                        case let (.success(c), .success(f)):
                            let listItem = SearchListItem(currentWeather: c, forecast: f, searchword: searchword)
                            await container.append(listItem)
                        case let (.failure(error), _), let (_, .failure(error)):
                            print("failure....\(error.localizedDescription)")
                            throw error
                        }
                    } catch {
                        print("Decoding error: \(error)")
                        throw error
                    }
                }
            }
        }
        return await container.items
    }
}
