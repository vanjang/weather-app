//
//  SearchView.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    @Bindable var store: StoreOf<SearchReducer>
    
    init(store: StoreOf<SearchReducer>) {
        self.store = store
        store.send(.getPreviousSearchHistory)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .onTapGesture {
                            store.send(.fetchCities(keywords: [store.searchKeyword]))
                        }
                    TextField(
                        "London, Paris, Seoul...", text: $store.searchKeyword.sending(\.currentSearchKeyword)
                    )
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
                .padding(.horizontal, 16)
                
                if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                }
            
                WithViewStore(self.store, observe: { $0 }) { viewStore in
                    if viewStore.isLoading {
                        ProgressView()
                    }
                    
                    List(content: {
                        if let cities = viewStore.cities, !cities.isEmpty {
                            ForEach(cities) { city in
                                Text(city.name)
                            }
                        } else {
                            Text("No result found.")
                        }
                    })
                    .navigationTitle("Weather")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
    SearchView(store: Store(initialState: SearchReducer.State(), reducer: {
        SearchReducer()
    }))
}
