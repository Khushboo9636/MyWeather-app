//
//  Model.swift
//  MyWeather app
//
//  Created by Khushboo on 19/04/22.
//

import Foundation

struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String

}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
struct ValueOfCity: Codable {
    
    let lat, lon: Double
    let country: String
    let state: String?

}
