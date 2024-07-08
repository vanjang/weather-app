//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(store: Store(initialState: SearchReducer.State(), reducer: {
                SearchReducer()
            }))
        }
    }
}
