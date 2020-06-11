//
//  ChoiseVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/5/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import CoreLocation

class ChoiseVC: BaseVC {
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var vChoise: UIView!
    @IBOutlet weak var imgLoadGif: UIImageView!
    @IBOutlet weak var btnDoctor: UIButton!
    @IBOutlet weak var btnPatient: UIButton!
    weak var delegate = UIApplication.shared.delegate as? AppDelegate
    var locationManager: CLLocationManager?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(delegate?.allowNotification ?? true){
            allowNotification()
        }
        
    }
    override func initUI() {
        let font  = UIFont(name: Font.text, size: 18)
        btnDoctor.setTitle("Nhân viên y tế", for: .normal)
        btnDoctor.titleLabel?.font = font
        btnDoctor.setTitleColor(.white, for: .normal)
        btnDoctor.backgroundColor = .blue
        btnDoctor.setCornerRadius(20)
        
        btnPatient.setTitle("Người cách ly", for: .normal)
        btnPatient.titleLabel?.font = font
        btnPatient.setTitleColor(.white, for: .normal)
        btnPatient.backgroundColor = .red
        btnPatient.setCornerRadius(20)
        
        imgLoadGif.loadGif(asset: "ManaGif")
        imgLoadGif.contentMode = .scaleToFill
        vChoise.setCornerRadius(20)
        vChoise.borderWidth = 0.5
        vChoise.borderColor = .lightGray
        lbltitle.textColor = .darkText
        
    }
    @IBAction func onBtnDoctor(_ sender: Any) {
        let vc = RegisterVC(nibName: String(describing: RegisterVC.self) , bundle: nil)
        pushVC(vc)
    }
    
    @IBAction func onBtnPatient(_ sender: Any) {
        let vc = LoginVC(nibName: String(describing: LoginVC.self) , bundle: nil)
        pushVC(vc)
    }
    
    @IBAction func onbtnLogin(_ sender: Any) {
        let vc = LoginVC(nibName: String(describing: LoginVC.self) , bundle: nil)
        pushVC(vc)
    }
    @IBAction func onForgotPassword(_ sender: Any) {
        let vc = ForgotPasswordVC(nibName: String(describing: ForgotPasswordVC.self) , bundle: nil)
        pushVC(vc)
    }
    
    func allowNotification(){
        Utilities.share.alertShowNotification("Thông báo", "Vui lòng bật thông báo cho ứng dụng trong phần cài đặt", "OK", self) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
}

extension ChoiseVC {
    func settingLocation(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    func getLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        if status == .denied || status == .restricted || CLLocationManager.locationServicesEnabled(){
            // show alert request usser enable location
            locationManager?.requestAlwaysAuthorization()
        }
        
        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined){
            locationManager?.requestWhenInUseAuthorization()
            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            locationManager?.requestAlwaysAuthorization()
            return
        }
        
        locationManager?.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            print("New location is \(locations)")
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            debugPrint("Lat: \(latitude!) || Long: \(longitude!)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("===== Can not get location =====")
        Utilities.share.alertShowNotification("ERROR!", "Please allow we to get your location in your app's setting!", "OK", self) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
}
//MARK: - CLLocationManagerDelegate
extension ChoiseVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch  status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user did not allow to get location data")
        case .restricted:
            print("parental control settinf disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't show before, usser haven't tab allow/disallow ")
        default:
            print("can not check")
        }
    }
}
