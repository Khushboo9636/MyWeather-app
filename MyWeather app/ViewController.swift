//
//  ViewController.swift
//  MyWeather app
//
//  Created by Khushboo on 19/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var discribe: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var update: UIButton!
    
    var lat = 21.1938 , long = 81.3509
    let apiKey = "116ed05660f434663de6b507aaf56c44"
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStyle(button: update)
        
        getData()
        
        // Do any additional setup after loading the view.
    }
    func fetchLocationLatAndLong(){
        if var location = name.text{
            let locationArray = location.components(separatedBy: " ")
            location = locationArray.joined(separator: "+")
            let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(location)&limit=5&appid=\(apiKey)"
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!, completionHandler: {data , response, error in
                guard let data = data , error == nil else {
                    return
                }
                var json: [ValueOfCity]?
                do{
                    json = try JSONDecoder().decode([ValueOfCity].self, from: data)
                }
                catch{
                    print("error: \(error)")
                }
                guard let result = json else {
                    return
                }
                self.lat = result[0].lat
                self.long = result[0].lon
                self.getData()
                                       
            }).resume()
           
        }
    }
    func getData(){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url! , completionHandler: {data,response,error in
            guard let data = data , error == nil else {
                return
            }
            var json: WeatherResponse?
            do{
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch{
                print("error: \(error)")
            }
            
            guard let result = json else {
                return
            }
            DispatchQueue.main.async{
                self.cityName.text = result.name + ", " + result.sys.country!
                //self.countryName.text = result.sys.country
                
                self.temp.text = "\(Int(result.main.temp)) °C"
                if !result.weather.isEmpty{
                    self.discribe.text = result.weather[0].description.capitalized
                }
                self.icon.downloaded(from: "https://openweathermap.org/img/wn/\(result.weather[0].icon)@2x.png")
            }
        }).resume()
        
    }

    @IBAction func showAll(_ sender: Any) {
        fetchLocationLatAndLong()
    }
    func buttonStyle(button: UIButton){
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

