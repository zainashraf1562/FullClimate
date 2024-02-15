//
//  WeatherViewController.swift
//  FullClimate
//
//  Created by Zain Ashraf on 2/14/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    @IBOutlet var infoView: UIView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var tempImageView: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextField.delegate = self
        weatherManager.delegate=self
        viewSetup()
        
    }
    
    func viewSetup(){
        infoView.layer.cornerRadius = 20
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = 0.5
        infoView.layer.shadowOffset = CGSize(width: 0, height: 5)
        infoView.layer.shadowRadius = 5
    }

}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.sync {
            self.tempLabel.text = weather.temperatureString
            self.locationLabel.text = weather.cityName
            self.tempImageView.image = UIImage(systemName: weather.conditionName)
            
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController:UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text=""
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.placeholder = "Search"
            return true
        }else {
            textField.placeholder = "Welcome to No Man's Land GENIUS!"
            return false
        }
    }
}



//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func returnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
