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
        fetchCurrentWeather: { try await request(endpoint: .currentWeather, searchword: $0) },
        fetchForecast: { try await request(endpoint: .forecast, searchword: $0) },
        fetchRecentHistory: { try await request(endpoint: .recentHistory, searchword: $0) })
}

extension DependencyValues {
    var weatherClient: WeatherClient {
        get { self[WeatherClient.self] }
        set { self[WeatherClient.self] = newValue }
    }
}

extension WeatherClient {
    private static let cache: URLCache = {
        let memoryCapacity = 10 * 1024 * 1024 // 10 MB
        let diskCapacity = 50 * 1024 * 1024 // 50 MB
        return URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "weatherCache")
    }()
    
    private static func request<T: Decodable>(endpoint: WeatherEndpoint, searchword: String) async throws -> Result<T, Error> {
        let apiKey = getAPIKey()
        let request = createRequest(endpoint: endpoint, searchword: searchword, apiKey: apiKey)
        
        if let cachedResponse = checkCache(for: request, searchword: searchword) {
            print("Using cached data for \(searchword)")
            let decoded = try decodeData(T.self, from: cachedResponse.data)
            return .success(decoded)
        }
        
        do {
            let (data, response) = try await fetchData(with: request)
            let decoded = try decodeData(T.self, from: data)
            cacheResponse(data, response: response, for: request)
            print("Fetched new data for \(searchword)")
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
    
    private static func getAPIKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "API Key") as? String ?? ""
    }
    
    private static func createRequest(endpoint: WeatherEndpoint, searchword: String, apiKey: String) -> URLRequest {
        let url = URL(string: "https://api.tomorrow.io/v4/weather/\(endpoint.rawValue)")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: searchword),
            URLQueryItem(name: "apikey", value: apiKey),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = ["accept": "application/json"]
        request.cachePolicy = .returnCacheDataElseLoad
        return request
    }
    
    // searchword for logging
    private static func checkCache(for request: URLRequest, searchword: String) -> CachedURLResponse? {
        if let cachedResponse = cache.cachedResponse(for: request),
           let userInfo = cachedResponse.userInfo,
           let cacheDate = userInfo["cacheDate"] as? Date {
            // Network call is limited, therefore set 2 minutes for Time To Live.
            let ttl: TimeInterval = 120 
            if Date().timeIntervalSince(cacheDate) < ttl {
                return cachedResponse
            } else {
                print("Cache expired for \(searchword)")
            }
        }
        return nil
    }
    
    private static func fetchData(with request: URLRequest) async throws -> (Data, URLResponse) {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: configuration)
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
            throw error
        }
        return (data, response)
    }
    
    private static func decodeData<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private static func cacheResponse(_ data: Data, response: URLResponse, for request: URLRequest) {
        let cachedResponse = CachedURLResponse(response: response, data: data, userInfo: ["cacheDate": Date()], storagePolicy: .allowed)
        cache.storeCachedResponse(cachedResponse, for: request)
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
