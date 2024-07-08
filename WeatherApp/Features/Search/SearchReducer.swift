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
    }
    
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
                                let currentWeather = try await self.weatherClient.fetchCurrentWeather(keyword)
                                let forecast = try await self.weatherClient.fetchForecast(keyword)
                                
                                let listItem = SearchLocationListItem(currentWeather: currentWeather, forecast: forecast, searchKeyword: keyword)
                                await container.append(listItem)
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
                await send(.fetchItems(keywords: searchKeywords))
            }
        case .setError(let error):
            state.errorMessage = error
            state.isLoading = false
            return .none
        case .setDetailPage(let isPresented):
            state.shouldShowDetailPage = isPresented
            return .none
        case .setSelectedItem(let item):
            state.selectedListItem = item

            return .none
        }
    }
    
}
