//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Chandni Pambhar on 27/03/23.
//

import Foundation
class WeatherViewModel {
    
    let weatherAppManager = WeatherAppManager.shared
    
    func fetchLocationFromCity(cityName:String, completion : @escaping ((CurrentWeather?,Error?)->())) {
        weatherAppManager.getLatLongFromCity(cityName: cityName) { result in
            switch result {
            case .success(let cities):
                if let city = cities.first {
                    self.fetchWeather(city.lat, city.lon, completion: completion)
                    UserDefaults.standard.set(city.name, forKey: lastSearchKey)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchWeather(_ lat: Double, _ lon: Double, completion : @escaping ((CurrentWeather?,Error?)->())) {
        //call weather api
        WeatherAppManager.shared.getCurrentWeather(lat: lat, lon: lon) { result in
            switch result {
            case .success(let weather):
                completion(weather,nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
