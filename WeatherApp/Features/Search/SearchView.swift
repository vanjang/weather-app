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
                            store.send(.fetchItems(keywords: [store.searchKeyword]))
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
                        if let items = viewStore.listItems, !items.isEmpty {
                            ForEach(items) { item in
                                Text(item.locationName)
                                    .onTapGesture {
                                        viewStore.send(.setDetailPage(isPresented: true))
                                        viewStore.send(.setSelectedItem(item))
                                    }
                            }
                        } else {
                            Text("No result found.")
                        }
                    })
                    .navigationTitle("Weather")
                    .navigationBarTitleDisplayMode(.inline)
                    .sheet(isPresented: viewStore.binding(get: \.shouldShowDetailPage,
                                                          send: SearchReducer.Action.setDetailPage(isPresented:))) {
                        let store = Store(initialState: DetailReducer.State(searchKeyword: store.selectedListItem?.searchKeyword ?? ""), reducer:  { DetailReducer() })
                        DetailView(store: store)
                    }
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
