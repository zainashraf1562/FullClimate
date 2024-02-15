//
//  WeatherManager.swift
//  FullClimate
//
//  Created by Zain Ashraf on 2/15/24.
//

import Foundation
import CoreLocation

protocol  WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=219f31f58209f695f79668db78e4b321"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)&units=imperial"
        Task{
            try await performRequest(with: urlString)
        }
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(lon)&units=imperial"
        Task{
            try await performRequest(with: urlString)
        }
    }
    
    func performRequest(with urlString: String) async throws{
        print(urlString)
        guard let url = URL(string: urlString) else{
            throw NetworkError.invalidURL
        }
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode==200 else{
            throw NetworkError.invalidResponse
        }
        if let weather = self.parseJSON(data){
            delegate?.didUpdateWeather(self, weather:weather)
        }
    }
    
    func parseJSON(_ weatherData: Data)-> WeatherModel?
    {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let minTemp = decodedData.main.temp_min
            let maxTemp = decodedData.main.temp_max
            let windSpeed = decodedData.wind.speed
            let humidity = decodedData.main.humidity
            
            let  weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, minTemp: Int(minTemp), maxTemp: Int(maxTemp), windSpeed: Int(windSpeed), humidity: Int(humidity))
            return weather
            
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}

enum NetworkError:Error{
    case invalidURL
    case invalidResponse
    case invalidData
}
