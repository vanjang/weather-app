//
//  SearchView.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField(
                        "New York, San Francisco, ...", text: .constant("")
                    )
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
                .padding(.horizontal, 16)
            
                List(["Seoul", "London", "Tokyo"], id: \.self) { item in
                    Text(item)
                }
                .navigationTitle("My Weather")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    SearchView()
}
