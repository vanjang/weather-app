//
//  DetailView.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    @Bindable var store: StoreOf<DetailReducer>
    
    init(store: StoreOf<DetailReducer>) {
        self.store = store
        store.send(.fetchCurrentWeather(keyword: store.state.searchKeyword))
        store.send(.fetchForecaset(keyword: store.state.searchKeyword))
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                Text(viewStore.state.currentWeatherItem?.locationName ?? "")
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                
                Text("Hourly Forecast")
                    .font(.headline)
                    .padding(.leading)
                
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewStore.state.hourlyItems ?? []) { item in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green)
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Text("\(item.desc)")
                                }
                                .padding(4)
                            
                        }
                    }
                }
                
                VStack {
                    Text("Daily Forecast")
                        .font(.headline)
                        .padding(.leading)
                    
                    ForEach(viewStore.state.dailyItems ?? []) { item in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .overlay {
                                Text("\(item.desc)")
                            }
                            .padding(4)
                    }
                    
                    if viewStore.state.recentHistoryItems != nil {
                        Text("Historical Forecast")
                            .font(.headline)
                            .padding(.leading)
                    }
                    
                    ForEach(viewStore.state.recentHistoryItems ?? []) { item in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .overlay {
                                Text("\(item.desc)")
                            }
                            .padding(4)
                        
                    }
                }
                
                Button(action: {
                    viewStore.send(.fetchRcentHistory(keyword: viewStore.searchKeyword))
                }) {
                    Text("Load Historical Forecast")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                
            }
            .overlay {
                if viewStore.state.isLoading {
                    ProgressView()
                }
            }
        }
    }
    
}

#Preview {
    DetailView(store: Store(initialState: DetailReducer.State(searchKeyword: ""), reducer: {
        DetailReducer()
    }))
}
