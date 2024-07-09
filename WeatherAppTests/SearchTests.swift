//
//  SearchTests.swift
//  WeatherAppTests
//
//  Created by myung hoon on 08/07/2024.
//

import XCTest
import ComposableArchitecture
@testable import WeatherApp

@MainActor
final class SearchTests: XCTestCase {
    
    var item: SearchListItem {
        let weatherData = WeatherData(time: "", values: WeatherValues(temperature: 21.0, weatherCode: 1001))
        let location = Location(lat: 0.0, lon: 0.0, name: "Milano, Lombardia, Italia", type: "")
        let weather = CurrentWeather(data: weatherData, location: location)
        let forecastWeatherData = WeatherData(time: "", values: WeatherValues(temperature: nil, weatherCode: 2100))
        let forecast = Forecast(timelines: Timelines(minutely: [], hourly: [forecastWeatherData], daily: []), location: location)
        return SearchListItem(currentWeather: weather, forecast: forecast, searchKeyword: "milano")
    }
    
    func testSearchResult() async throws {
        let store = TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        } withDependencies: { 
            $0.weatherClient = .testValue
        }
    
        await store.send(\.fetchItems, ["milano"]) { state in
            state.isLoading = true
        }
        
        await store.receive(\.fetchedItems, timeout: .seconds(2)) { [weak self] state in
            state.isLoading = false
            state.listItems = [self!.item]
        }

    }
    
    func testValidSearchKeyword() async throws {
        let store = TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        } withDependencies: {
            $0.weatherClient = .testValue
        }
        
        await store.send(\.currentSearchKeyword, "milano") {
            $0.searchKeyword = "milano"
        }
    }

    func testAlert() async throws {
        let store = TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        } withDependencies: {
            $0.weatherClient = .testValue
        }
        
        // Only case to present alerts in this app is when error occurs, so send an error.
        await store.send(\.setError, "error message") {
            $0.errorMessage = "error message"
        }
        
        await store.receive(\.setAlert) {
            $0.shouldShowAlert = true
        }
    }
    
    func testDetailPage() async throws {
        let store = TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        } withDependencies: {
            $0.weatherClient = .testValue
        }
        
        await store.send(\.setDetailPage, true) {
            $0.shouldShowDetailPage = true
        }
    }
    
    func testSelectedItem() async throws {
        let store = TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        } withDependencies: {
            $0.weatherClient = .testValue
        }
        
        await store.send(\.setSelectedItem, item) { [weak self] state in
            state.selectedListItem = self!.item
        }
    }
}
