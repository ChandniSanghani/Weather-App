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
    
    //MARK:- LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchbar.delegate = self
        CLLocationManager().requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            if let cityname = UserDefaults.standard.value(forKey: lastSearchKey) as? String {
                self.fetchLocationFromSearchText(cityName: cityname)
            }
    }

    //MARK:- Custom methods
    private func updateUI() {
        if let currentWeather = self.currentWeather {
            self.cityNameLabel.text = currentWeather.name
            self.timeLabel.text = dateFormater(date: currentWeather.dt, dateFormat: "HH:mm E")
            self.temperatureLabel.text = "\(currentWeather.main.temp.doubleToString())°"
            self.weatherDescLabel.text = currentWeather.weather.first!.description.capitalizingFirstLetter()
            
            if let url = URL.init(string: "https://openweathermap.org/img/wn/\(currentWeather.weather.first!.icon)@2x.png") {
                self.weatherImage.sd_setImage(with: url)
            }
        }
    }
    
    private func fetchLocationFromSearchText(cityName: String) {
        guard checkLocationPermissionGranted() else {
            return
        }
        weatherViewModel.fetchLocationFromCity(cityName: cityName, completion: { currentWeather in
            DispatchQueue.main.async {
                self.currentWeather = currentWeather
                self.updateUI()
            }
        })
    }
    
    private func checkLocationPermissionGranted() -> Bool {
        let status = CLLocationManager().authorizationStatus
        if status == CLAuthorizationStatus.notDetermined || status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    //MARK:- Helper Method
    private func dateFormater(date: TimeInterval, dateFormat: String) -> String {
        let dateText = Date(timeIntervalSince1970: date )
        let formater = DateFormatter()
        formater.timeZone = TimeZone(secondsFromGMT: self.currentWeather?.timezone ?? 0)
        formater.dateFormat = dateFormat
        return formater.string(from: dateText)
        
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

