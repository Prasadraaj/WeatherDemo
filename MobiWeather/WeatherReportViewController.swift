//
//  WeatherReportViewController.swift
//  MobiWeather
//
//  Created by Adwitech on 07/05/21.
//  Copyright © 2021 techvedika. All rights reserved.
//

import UIKit

enum MainType: String {
    case clear_sky = "clear sky"
    case few_clouds = "few clouds"
    case scattered_clouds = "scattered clouds"
    case broken_clound = "broken clouds"
    case shower_rain = "shower rain"
    case rain = "rain"
    case thunderstorm = "thunderstorm"
    case snow = "snow"
    case mist = "mist"
    
}

class WeatherReportViewController: UIViewController {

    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    var locationObject: [String: Any]!
    var ttt: MainType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getWeatherReport()
    }
    
    func getWeatherReport() {
        let progressHUD = ProgressHUD.init(title: "Loading")
        self.view.addSubview(progressHUD)
        let coordinates = (locationObject["latitude"] as! Double, locationObject["longitude"] as! Double)
        MbNetworkManager.shared.makeGetRequest(coordinates: coordinates, handler: {(response, error) in
            DispatchQueue.main.async {
                progressHUD.hide()
                if let response = response {
                    self.cityNameLabel.text = response["name"] as? String ?? ""
                    if let main = response["main"] as? [String :Any] {
                        self.tempLabel.text = "\(main["temp"] as? Double ?? 0) °C"
                        self.humidityLabel.text = "Humidity: \(main["humidity"] as? Double ?? 0)"
                    }
                    if let weather = response["weather"] as? [[String :Any]] {
                        self.ttt = MainType(rawValue: weather.first?["description"] as? String ?? "")
                        self.mainLabel.text = weather.first?["main"] as? String ?? ""
                    }
                    
                    switch self.ttt {
                    case .broken_clound:
                        self.weatherImageView.image = UIImage(named: "04d")
                    case .few_clouds:
                        self.weatherImageView.image = UIImage(named: "02d")
                    case .scattered_clouds:
                        self.weatherImageView.image = UIImage(named: "03d")
                    case .clear_sky:
                        self.weatherImageView.image = UIImage(named: "01d")
                    case .shower_rain:
                        self.weatherImageView.image = UIImage(named: "09d")
                    case .rain:
                        self.weatherImageView.image = UIImage(named: "10d")
                    case .thunderstorm:
                        self.weatherImageView.image = UIImage(named: "11dd")
                    case .snow:
                        self.weatherImageView.image = UIImage(named: "13d")
                    case .mist:
                        self.weatherImageView.image = UIImage(named: "50d")
                    default:
                        self.weatherImageView.image = UIImage(named: "04d")
                    }
                }
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
