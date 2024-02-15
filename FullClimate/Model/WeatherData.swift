//
//  WeatherData.swift
//  FullClimate
//
//  Created by Zain Ashraf on 2/15/24.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [weatherInfo]
    let wind: Wind
}
struct Main: Codable{
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
}
struct weatherInfo: Codable{
    let id: Int
}
struct Wind: Codable{
    let speed: Double
}
