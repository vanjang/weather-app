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
    
    func testSearchResult() async throws {
        let store = TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        } withDependencies: { 
            $0.weatherClient = .testValue
        }
    
        let mocks = Mocks()
        
        await store.send(\.fetchItems, [mocks.searchword]) {
            $0.isLoading = true
        }
        
        await store.receive(\.didFetchItems, timeout: .seconds(2)) {
            $0.isLoading = false
            $0.listItems = [mocks.searchListItem]
        }

    }
    
    func testValidSearchword() async throws {
        let store = TestStore(initialState: SearchReducer.State()) {
            SearchReducer()
        } withDependencies: {
            $0.weatherClient = .testValue
        }
        
        let mocks = Mocks()
        
        await store.send(\.didSearchwordChanged, mocks.searchword) {
            $0.searchword = mocks.searchword
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
        
        let mocks = Mocks()
        
        await store.send(\.setSelectedItem, mocks.searchListItem) {
            $0.selectedListItem = mocks.searchListItem
        }
    }
}
