//
//  WeatherViewModelTests.swift
//  Weather AppTests
//
//  Created by Chandni Pambhar on 28/03/23.
//

import XCTest
@testable import Weather_App

final class WeatherViewModelTests: XCTestCase {

    var weatherViewModel: WeatherViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        weatherViewModel = WeatherViewModel()
    }

    func test_fetchLocationFromValidCityWithSuccess() {
        let cityName = "Chicago"
        weatherViewModel.fetchLocationFromCity(cityName: cityName) { currentWeather, error in
            XCTAssertNil(error)
            XCTAssertNotNil(currentWeather)
            XCTAssertEqual(cityName, currentWeather!.name)
        }
    }
    
    func test_fetchLocationFromCityWithError() {
        let cityName = "xyz"
        weatherViewModel.fetchLocationFromCity(cityName: cityName) { currentWeather, error in
            XCTAssertNil(currentWeather)
            XCTAssertNotNil(error)
        }
    }
    
    func test_fetchWeatherDetailWithSuccess() {
        let lat = 41.8781
        let long = -87.6298
        weatherViewModel.fetchWeather(lat, long) { currentWeather, error in
            XCTAssertNil(error)
            XCTAssertNotNil(currentWeather)
            XCTAssertEqual(lat, currentWeather!.coord.lat)
            XCTAssertEqual(long, currentWeather!.coord.lon)
        }
    }
    
    func test_fetchWeatherDetailWithError() {
        weatherViewModel.fetchWeather(0,0) { currentWeather, error in
            XCTAssertNil(currentWeather)
            XCTAssertNotNil(error)
        }
    }
}
