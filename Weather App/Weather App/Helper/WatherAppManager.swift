//
//  WatherAppManager.swift
//  Weather App
//
//  Created by Chandni Pambhar on 24/03/23.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case decodingError
}

class WeatherAppManager {
    
    static let shared = WeatherAppManager()
    
    
    private init() {}
 
    func getCurrentWeather(lat:Double,lon:Double,completion: @escaping (Result<CurrentWeather,NetworkError>) -> Void) {
        guard let url = URL(string: "\(weatherBaseURL)?lat=\(lat)&lon=\(lon)&units=metric&appid=\(weatherAPIKey)") else {
            completion(.failure(.serverError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let weather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
 
    }
    
    func getLatLongFromCity(cityName: String,completion: @escaping (Result<[CityObject],NetworkError>) -> Void) {
        guard let url = URL(string:
        "\(geoCodingBaseURL)?q=\(cityName)&appid=\(weatherAPIKey)")
        else {
            completion(.failure(.serverError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let object = try JSONDecoder().decode([CityObject].self, from: data)
                guard object.count > 0 else {
                    completion(.failure(.serverError))
                    return
                }
                completion(.success(object))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
 
    }
}
