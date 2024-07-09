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
        // default setups
        store.send(.fetchCurrentWeather(keyword: store.state.searchword))
        store.send(.fetchForecaset(keyword: store.state.searchword))
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                
                if let item = viewStore.state.currentWeatherItem {
                    CurrentWeatherView(item: item)
                        .frame(maxWidth: .infinity)
                }
                
                Text("Hourly Forecast")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 3) {
                        ForEach(viewStore.state.hourlyItems ?? []) { item in
                            HourlyForecastCard(item: item)
                                .frame(width: 100, height: 100)
                        }
                    }
                }
                .padding(.leading, 16)
                
                VStack {
                    Text("Daily Forecast")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(viewStore.state.dailyItems ?? []) { item in
                        DailyForecastCard(item: item)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                    }
                    
                    if viewStore.state.recentHistoryItems != nil {
                        Text("Historical Forecast")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    ForEach(viewStore.state.recentHistoryItems ?? []) { item in
                        DailyForecastCard(item: item)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                    }
                }
                
                Button(action: {
                    viewStore.send(.fetchRcentHistory(keyword: viewStore.searchword))
                }) {
                    Text("Load Historical Forecast")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(Color.blue)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(16)
            }
            .alert(isPresented: viewStore.binding(get: \.shouldShowAlert,
                                                  send: DetailReducer.Action.setAlert(isPresented:)),
                   content: {
                Alert(title: Text(viewStore.state.errorMessage ?? ""))
            })
            .opacity(viewStore.state.isLoading ? 0 : 1)
            .overlay {
                if viewStore.state.isLoading {
                    ProgressView()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
}

#Preview {
    DetailView(store: Store(initialState: DetailReducer.State(searchword: ""), reducer: {
        DetailReducer()
    }))
}
