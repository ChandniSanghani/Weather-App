//
//  ViewController.swift
//  Weather App
//
//  Created by Chandni Pambhar on 24/03/23.
//

import UIKit
import SDWebImage
import CoreLocation

class WeatherViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherDescLabel: UILabel!
    @IBOutlet private weak var searchbar:UISearchBar!
    
    weak var currentWeather: CurrentWeather?
    var weatherViewModel = WeatherViewModel()
    
    var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    //MARK:- LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchbar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cityname = UserDefaults.standard.value(forKey: lastSearchKey) as? String {
            self.fetchLocationFromSearchText(cityName: cityname)
        }
    }
    
    //MARK:- UI updation method
    private func updateUI() {
        if let currentWeather = self.currentWeather {
            self.cityNameLabel.text = currentWeather.name
            self.timeLabel.text = currentWeather.dt.timeFromTimeInterval(dateFormat: "HH:mm E")
            self.temperatureLabel.text = "\(currentWeather.main.temp.doubleToString())°"
            self.weatherDescLabel.text = currentWeather.weather.first!.description.capitalizingFirstLetter()
            
            if let url = URL.init(string: "\(weathericonBaseURL)/\(currentWeather.weather.first!.icon)@2x.png") {
                self.weatherImage.sd_setImage(with: url)
            }
        }
    }
}

extension WeatherViewController {
    
    //MARK:- Custom methods
    private func fetchLocationFromSearchText(cityName: String) {
        guard checkLocationPermissionGranted() else {
            return
        }
        weatherViewModel.fetchLocationFromCity(cityName: cityName, completion: { currentWeather, error in
            DispatchQueue.main.async {
                if let _ = error {
                    self.displayAlert(title: serverErrorAlertTitle, message: serverErrorAlertMessage)
                } else {
                    self.currentWeather = currentWeather
                    self.updateUI()
                }
            }
        })
    }
    
    private func checkLocationPermissionGranted() -> Bool {
        let status = locationManager.authorizationStatus
        if status == CLAuthorizationStatus.notDetermined || status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            self.displayAlert(title: LocationErrorAlertTitle, message: LocationErrorAlertMessage)
            return false
        }
        return true
    }
    
}
    
extension WeatherViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //trim text
        searchBar.endEditing(true)
        guard let text = searchBar.text else { return }
        self.fetchLocationFromSearchText(cityName: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
