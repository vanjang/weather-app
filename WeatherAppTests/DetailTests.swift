//
//  DetailTests.swift
//  WeatherAppTests
//
//  Created by myung hoon on 09/07/2024.
//

import XCTest
import ComposableArchitecture
@testable import WeatherApp

@MainActor
final class DetailTests: XCTestCase {
 
    func testCurrentWeather() async throws {
        let store = TestStore(initialState: DetailReducer.State(searchKeyword: "")) {
            DetailReducer()
        } withDependencies: {
            $0.weatherClient = .testValue
        }
        
        let mocks = Mocks()
        
        await store.send(\.fetchCurrentWeather, mocks.searchKeyword) {
            $0.isLoading = true
        }
        
        await store.receive(\.fetchedCurrentWeather, timeout: .seconds(2)) {
            $0.isLoading = false
            $0.currentWeatherItem = CurrentWeatherItem(currentWeather: mocks.currentWeather)
        }
    }
    
    func testForecast() async throws {
        let store = TestStore(initialState: DetailReducer.State(searchKeyword: "")) {
            DetailReducer()
        } withDependencies: {
            $0.weatherClient = .testValue
        }
        
        let mocks = Mocks()
        
        await store.send(\.fetchForecaset, mocks.searchKeyword) {
            $0.isLoading = true
        }
        
        await store.receive(\.fetchedForecast, timeout: .seconds(2)) {
            $0.isLoading = false
            $0.hourlyItems = mocks.hourlyItems
            $0.dailyItems = mocks.dailyItems
        }
    }
    
    func testRecentHistoryForecast() async throws {
        let store = TestStore(initialState: DetailReducer.State(searchKeyword: "")) {
            DetailReducer()
        } withDependencies: {
            $0.weatherClient = .testValue
        }
        
        let mocks = Mocks()
        
        await store.send(\.fetchRcentHistory, mocks.searchKeyword) {
            $0.isLoading = true
        }
        
        await store.receive(\.fetchedRecentHistory, timeout: .seconds(2)) {
            $0.isLoading = false
            $0.recentHistoryItems = mocks.recentHistoryForecastItems
        }
    }
    
    func testError() async throws {
        let store = TestStore(initialState: DetailReducer.State(searchKeyword: "")) {
            DetailReducer()
        } withDependencies: {
            $0.weatherClient = .testValue
        }
        
        let errorMessage = "error message"
        await store.send(\.setError, errorMessage) {
            $0.errorMessage = errorMessage
        }
        
        await store.receive(\.setAlert) {
            $0.shouldShowAlert = true
        }
    }
    
    func testAlert() async throws {
        let store = TestStore(initialState: DetailReducer.State(searchKeyword: "")) {
            DetailReducer()
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
}
