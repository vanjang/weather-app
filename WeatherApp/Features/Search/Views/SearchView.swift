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
        // default setup
        store.send(.fetchSearchHistory)
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    List {
                        if let items = viewStore.listItems, !items.isEmpty {
                            ForEach(items) { item in
                                SearchCard(item: item)
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                    .listRowSeparator(.hidden)
                                    .onTapGesture {
                                        viewStore.send(.setDetailPage(isPresented: true))
                                        viewStore.send(.setSelectedItem(item))
                                    }
                            }
                        } else {
                            Text("No result found.")
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Weather")
                }
            }
            .sheet(isPresented: viewStore.binding(get: \.shouldShowDetailPage,
                                                  send: SearchReducer.Action.setDetailPage(isPresented:))) {
                let store = Store(initialState: DetailReducer.State(searchword: store.selectedListItem?.searchword ?? ""), reducer:  { DetailReducer() })
                DetailView(store: store)
            }
            .alert(isPresented: viewStore.binding(get: \.shouldShowAlert,
                                                  send: SearchReducer.Action.setAlert(isPresented:)), 
                   content: {
                Alert(title: Text(viewStore.state.errorMessage ?? ""))
            })
            .searchable(text: $store.searchword.sending(\.didSearchwordChanged),
                        prompt: "London, Seoul, Amsterdam...")
            .onSubmit(of: .search) {
                viewStore.send(.fetchItems(searchwords: [viewStore.state.searchword]))
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
    SearchView(store: Store(initialState: SearchReducer.State(), reducer: {
        SearchReducer()
    }))
}
