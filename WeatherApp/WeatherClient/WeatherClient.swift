//
//  WeatherClient.swift
//  WeatherApp
//
//  Created by myung hoon on 07/07/2024.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct WeatherClient {
    var fetchCurrentWeather: (String) async throws -> Result<CurrentWeather, Error>
    var fetchForecast: (String) async throws -> Result<Forecast, Error>
    var fetchRecentHistory: (String) async throws -> Result<HistoryForecast, Error>
}

private enum WeatherEndpoint: String {
    case currentWeather = "realtime"
    case forecast = "forecast"
    case recentHistory = "history/recent"
}

extension WeatherClient: DependencyKey {
    static var liveValue: WeatherClient = Self(
        fetchCurrentWeather: { try await request(endpoint: .currentWeather, searchkeyword: $0) },
        fetchForecast: { try await request(endpoint: .forecast, searchkeyword: $0) },
        fetchRecentHistory: { try await request(endpoint: .recentHistory, searchkeyword: $0) })
}

extension DependencyValues {
    var weatherClient: WeatherClient {
        get { self[WeatherClient.self] }
        set { self[WeatherClient.self] = newValue }
    }
}

extension WeatherClient {
    private static func request<T: Decodable>(endpoint: WeatherEndpoint, searchkeyword: String) async throws -> Result<T, Error> {
        // API Key
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API Key") as? String ?? ""
        
        // URL
        let url = URL(string: "https://api.tomorrow.io/v4/weather/\(endpoint.rawValue)")!
        
        // Query
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: searchkeyword),
          URLQueryItem(name: "apikey", value: apiKey),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        // Request
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]

        // Decoding
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        }
        catch {
            return .failure(error)
        }
    }
}

extension WeatherClient: TestDependencyKey {
    static let testValue: WeatherClient = Self(
        fetchCurrentWeather: { keyword in
            fetchMockData(filename: "mockCurrentWeather")
        },
        fetchForecast: { keyword in
            fetchMockData(filename: "mockForecast")
        },
        fetchRecentHistory: { keyword in
            fetchMockData(filename: "mockRecentHistory")
        }
    )
}
