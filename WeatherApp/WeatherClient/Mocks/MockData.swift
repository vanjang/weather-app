//
//  MockData.swift
//  WeatherApp
//
//  Created by myung hoon on 09/07/2024.
//

import Foundation

func fetchMockData<T: Decodable>(filename: String) -> Result<T, Error> {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: "json")
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)
        return .success(decoded)
    } catch {
        print("Couldn't parse \(filename) as \(T.self):\n\(error)")
        return .failure(error)
    }
}
