//
//  ViewController.swift
//  Wether
//
//  Created by 柿沼儀揚 on 2020/07/30.
//  Copyright © 2020 柿沼儀揚. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    let gradientLayer = CAGradientLayer()
    let apikey = "4ceeb5ab1d31149123223d0dffc2d84c"
    var latitude = 35.606249
    var longitude = 139.734855
    var activityIndicator : NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //グラデーションの作成？
        backgroundView.layer.addSublayer(gradientLayer)
        //CGFloatはbit数によって変わる型
        let indicationSize: CGFloat = 70
        //真ん中に表示
        let indicationFrame = CGRect(x: (view.frame.width - indicationSize)/2, y: (view.frame.height - indicationSize)/2, width: indicationSize, height: indicationSize)
        activityIndicator = NVActivityIndicatorView(frame: indicationFrame, type: .lineSpinFadeLoader, color: UIColor.white, padding: 20)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        //アプリの使用中に位置情報サービスを使用するユーザーの許可を要求
        locationManager.requestWhenInUseAuthorization()
        //        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            //desiredAccuracyを最高レベルにする
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    //viewが遷移するたびに実行
    override func viewWillAppear(_ animated: Bool) {
        setUpGradationBlueBackground()
    }
    func locationManager(_ manager: CLLocationManager ,didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let urlString: String = "http://api.openweathermap.org/data/2.5/whether?lat=\(latitude)&Ion=\(longitude)&appid=\(apikey)&Units=netric"
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        //httpリクエスト
        AF.request(urlString).response {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.value {
                let jsonResponse = JSON(responseStr)
                let jsonWether = jsonResponse["whether"].array![0]
                let jsonTemp = jsonRequest["main"]
                let iconName = jsonWether["icon"].stringValue
            }
        }
    }
//青のグラデーションの背景のセットアップ
func setUpGradationBlueBackground(){
    let topColor = UIColor(displayP3Red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
    let bottomColor = UIColor(displayP3Red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [topColor,bottomColor]
}
//グレーのグラデーションの背景のセットアップ
func setUpGradationGreyBackground(){
    let topColor = UIColor(displayP3Red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
    let bottomColor = UIColor(displayP3Red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [topColor,bottomColor]
    
}

}

