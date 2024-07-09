//
//  Mocks.swift
//  WeatherAppTests
//
//  Created by myung hoon on 09/07/2024.
//

import Foundation
@testable import WeatherApp

struct Mocks {
    let searchword = "milano"
    
    let weatherData = WeatherData(time: "", values: WeatherValues(temperature: 21.19, weatherCode: 1001))
    let location = Location(lat: 0.0, lon: 0.0, name: "Milano, Lombardia, Italia", type: "")
    
    var currentWeather: CurrentWeather {
        CurrentWeather(data: weatherData, location: location)
    }
    
    var forecastWeatherData: WeatherData {
        WeatherData(time: "", values: WeatherValues(temperature: nil, weatherCode: 2100))
    }
    
    var forecast: Forecast {
        Forecast(timelines: Timelines(minutely: [], hourly: [forecastWeatherData], daily: []), location: location)
    }
    var searchListItem: SearchListItem {
        SearchListItem(currentWeather: currentWeather, forecast: forecast, searchword: searchword)
    }
    
    let day1 = DailyWeatherValues(temperatureAvg: 22.76,
                                  temperatureMax: 25.14,
                                  temperatureMin: 21.18,
                                  weatherCodeMin: 2100,
                                  weatherCodeMax: 2100)
    
    let day2 = DailyWeatherValues(temperatureAvg: 23.1,
                                  temperatureMax: 26.41,
                                  temperatureMin: 20.51,
                                  weatherCodeMin: 1001,
                                  weatherCodeMax: 1001)
    
    let day3 = DailyWeatherValues(temperatureAvg: 21.26,
                                  temperatureMax: 23.39,
                                  temperatureMin: 17.6,
                                  weatherCodeMin: 4001,
                                  weatherCodeMax: 4001)
    
    let day4 = DailyWeatherValues(temperatureAvg: 25.58,
                                  temperatureMax: 29.77,
                                  temperatureMin: 19.47,
                                  weatherCodeMin: 1001,
                                  weatherCodeMax: 1001)
    
    let day5 = DailyWeatherValues(temperatureAvg: 29.08,
                                  temperatureMax: 34.23,
                                  temperatureMin: 24.07,
                                  weatherCodeMin: 1000,
                                  weatherCodeMax: 1000)
    
    let day6 = DailyWeatherValues(temperatureAvg: 27.23,
                                  temperatureMax: 29.05,
                                  temperatureMin: 24.36,
                                  weatherCodeMin: 1001,
                                  weatherCodeMax: 1001)
    
    var dailyItems: [DailyItem] {
        [
            DailyItem(data: DailyWeatherData(time: "2024-07-07T21:00:00Z", values: day1), isHistoric: false),
            DailyItem(data: DailyWeatherData(time: "2024-07-08T21:00:00Z", values: day2), isHistoric: false),
            DailyItem(data: DailyWeatherData(time: "2024-07-09T21:00:00Z", values: day3), isHistoric: false),
            DailyItem(data: DailyWeatherData(time: "2024-07-10T21:00:00Z", values: day4), isHistoric: false),
            DailyItem(data: DailyWeatherData(time: "2024-07-11T21:00:00Z", values: day5), isHistoric: false),
            DailyItem(data: DailyWeatherData(time: "2024-07-12T21:00:00Z", values: day6), isHistoric: false)
        ]
    }
    
    let hour1 = WeatherData(time: "2024-07-08T04:00:00Z", values: WeatherValues(temperature: 22.63, weatherCode: 2100))
    let hour2 = WeatherData(time: "2024-07-08T05:00:00Z", values: WeatherValues(temperature: 23.86, weatherCode: 1001))
    let hour3 = WeatherData(time: "2024-07-08T06:00:00Z", values: WeatherValues(temperature: 24.15, weatherCode: 1001))
    let hour4 = WeatherData(time: "2024-07-08T07:00:00Z", values: WeatherValues(temperature: 25.14, weatherCode: 2100))
    let hour5 = WeatherData(time: "2024-07-08T08:00:00Z", values: WeatherValues(temperature: 24.76, weatherCode: 1001))
    
    var hourlyItems: [HourlyItem] {
        [
            HourlyItem(data: hour1),
            HourlyItem(data: hour2),
            HourlyItem(data: hour3),
            HourlyItem(data: hour4),
            HourlyItem(data: hour5),
        ]
    }
    
    let historicDay1 = DailyItem(data: DailyWeatherData(time: "2024-07-07T05:00:00Z", values: DailyWeatherValues(temperatureAvg: 13.86, temperatureMax: 17.63, temperatureMin: 8.63, weatherCodeMin: 1000, weatherCodeMax: 1000)), isHistoric: true)
    let historicDay2 = DailyItem(data: DailyWeatherData(time: "2024-07-08T05:00:00Z", values: DailyWeatherValues(temperatureAvg: 16.05, temperatureMax: 18.5, temperatureMin: 11.81, weatherCodeMin: 1001, weatherCodeMax: 1001)), isHistoric: true)
    
    var recentHistoryForecastItems: [DailyItem] {
        [historicDay1, historicDay2]
    }
}
