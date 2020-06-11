//
//  Utilities.swift
//  Management Covid
//
//  Created by Mai Tài on 3/27/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
class Utilities: NSObject {
    static let share = Utilities()
    
    func createVC(SBName: String,_ VCName: String)-> UIViewController{
        return UIStoryboard.init(name: SBName, bundle: nil).instantiateViewController(identifier: VCName)
    }
    
    func getDays(_ timeInterVal: Int) -> String{
        let date = getDateTimeFromTimeStapm(Double(timeInterVal), "MM/dd/yyyy HH:mm:ss")
        let strDate = date.timeAgoSinceDateUTC()
        return strDate
//        date.convertUTCToLocal()
    }
    
    func getDateTimeFromTimeStapm(_ timestamp: Double,_ dateFormat: String)-> String{
        let date = Date(timeIntervalSince1970: timestamp/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormat //"dd:MM:yyyy" HH:mm //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func convertFromString(_ strDate: String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'-'MM'-'yyyy"
        let date = dateFormatter.date(from: strDate)
        return date
    }
    func alertNotification(_ title: String,_ message: String, _ btnTitle: String,_ view: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertAction.Style.default, handler: { (_) in
            
        }))
        view.present(alert, animated: true, completion: nil)
    }
    
    func alertShowNotification(_ title: String,_ message: String, _ btnTitle: String,_ view: UIViewController,_ complete: @escaping(Int)->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertAction.Style.default, handler: { (_) in
            complete(0)
        }))
        view.present(alert, animated: true, completion: nil)
    }
    
    func alertConfirm(_ title: String,_ message: String, _ btnLeft: String, _ btnRight: String,_ view: UIViewController,_ complete: @escaping(Int)->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btnLeft, style: UIAlertAction.Style.default, handler: { (_) in
            complete(0)
        }))
        alert.addAction(UIAlertAction(title: btnRight, style: UIAlertAction.Style.default, handler: { (_) in
            complete(1)
        }))
        view.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UserDefault--UserModal
    func getToken() -> String{
        if let data = UserDefaults.standard.value(forKey: "token") as? Data {
            return try! PropertyListDecoder().decode(String.self, from: data)
        }
        return ""
    }
    
    func setToken(_ token: String){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(token), forKey :"token")
        UserDefaults.standard.synchronize()
    }
    
    
    
    func getcurrUser() -> UserModal{
        if let data = UserDefaults.standard.value(forKey: "currUser") as? Data {
            return try! PropertyListDecoder().decode(UserModal.self, from: data)
        }
        return UserModal()
    }
    
    func setcurrUser(_ currUser:UserModal){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(currUser), forKey :"currUser")
        UserDefaults.standard.synchronize()
    }
}
