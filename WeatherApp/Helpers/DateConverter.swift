//
//  DateConverter.swift
//  WeatherApp
//
//  Created by myung hoon on 08/07/2024.
//

import Foundation

class DateConverter {
    private static let isoDateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    private static let dateFormatter: DateFormatter = DateFormatter()
    private static func convertToDate(from dateString: String) -> Date? {
        isoDateFormatter.date(from: dateString)
    }
    
    enum DateStringType: String {
        case dayMonth = "MMM d"
        case weekday = "E"
        case time = "HH:mm"
    }
    
    static func getDateString(from string: String, type: DateStringType) -> String {
        guard let date = convertToDate(from: string) else { return "" }
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: date)
    }
}
