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
        case fetchItems(keywords: [String])
        case didFetchItems([SearchListItem])
        case saveKeyword(String)
        case setDetailPage(isPresented: Bool)
        case setSelectedItem(SearchListItem)
        case setError(String)
        case setAlert(isPresented: Bool)
    }
    
    private let localSavingKey = "searchKeywords"
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didSearchwordChanged(let searchword):
            let lastKeyword = state.searchword
            state.searchword = searchword
            let currentKeyword = state.searchword
            
            let keywordClearedFromKeyboard = currentKeyword.isEmpty && !lastKeyword.isEmpty
            
            // only fetch when user deleted search keyword entiely in order to prevent unnecessary API calls.
            if keywordClearedFromKeyboard {
                return .send(.fetchSearchHistory)
            } else {
                return .none
            }
        case .fetchItems(let keywords):
            state.isLoading = true
            return .run { send in
                let items = try await fetchWeatherData(forKeywords: keywords, weatherClient: self.weatherClient)
                await send(.didFetchItems(items))
            }
        case .didFetchItems(let items):
            state.listItems = items
            state.isLoading = false
            let keyword = state.searchword
            
            if keyword.isEmpty {
                return .none
            } else {
                return .run { send in
                    await send(.saveKeyword(keyword))
                }
            }
        case .saveKeyword(let keyword):
            var keywords = [keyword]
            
            // save keywords if not duplicated.
            if let searchwords = UserDefaults.standard.array(forKey: localSavingKey) as? [String], !searchwords.contains(keyword) {
                keywords += searchwords
            }
            
            UserDefaults.standard.set(Array(Set(keywords)), forKey: localSavingKey)
            
            return .none
        case .fetchSearchHistory:
            let searchwords = UserDefaults.standard.array(forKey: localSavingKey) as? [String] ?? []
            
            return .run { send in
                await send(.fetchItems(keywords: searchwords))
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
    func fetchWeatherData(forKeywords keywords: [String], weatherClient: WeatherClient) async throws -> [SearchListItem] {
        let container = SearchListContainer()

        await withThrowingTaskGroup(of: Void.self) { taskGroup in
            for keyword in keywords {
                taskGroup.addTask {
                    do {
                        async let currentWeather = weatherClient.fetchCurrentWeather(keyword)
                        async let forecast = weatherClient.fetchForecast(keyword)

                        let (currentWeatherResult, forecastResult) = try await (currentWeather, forecast)

                        switch (currentWeatherResult, forecastResult) {
                        case let (.success(c), .success(f)):
                            let listItem = SearchListItem(currentWeather: c, forecast: f, searchword: keyword)
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
