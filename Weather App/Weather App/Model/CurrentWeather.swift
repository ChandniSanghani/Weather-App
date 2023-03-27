//
//  CurrentWeather.swift
//  Weather App
//
//  Created by Chandni Pambhar on 24/03/23.
//


import Foundation

class CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let name: String
}

class Coord: Codable {
    let lon, lat: Double
}

class Weather: Codable {
    let id: Int
    let description, icon: String
}

class Main: Codable {
    let temp, temp_min, temp_max: Double
}

class Sys: Codable {
    let country: String
}

