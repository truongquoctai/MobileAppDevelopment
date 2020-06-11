//
//  Extension.swift
//  Management Covid
//
//  Created by Mai Tài on 4/5/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension String {
  public func timeAgoSinceDateUTC(_ format: String = "MM/dd/yyyy HH:mm:ss", numericDates: Bool = true, abbreviation: Bool = false) -> String {
      let convertedTime = self.convertUTCToLocal(format)
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      if let date = dateFormatter.date(from: convertedTime) {
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components: DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
          return convertedTime
        } else if (components.year! >= 1){
          return convertedTime
        } else if (components.month! >= 2) {
          return convertedTime
        } else if (components.month! >= 1){
          return convertedTime
        } else if (components.weekOfYear! >= 2) {
          return convertedTime
        } else if (components.weekOfYear! >= 1){
          return convertedTime
        } else if (components.day! >= 2) {
          return convertedTime
        } else if (components.day! >= 1){
          if (numericDates){
            if abbreviation {
              return "1d ago"
            } else {
              return "1 day ago"
            }
          } else {
            return "Yesterday"
          }
        } else if (components.hour! >= 2) {
          if abbreviation {
            return "\(components.hour!)h ago"
          } else {
            return "\(components.hour!) hours ago"
          }
        } else if (components.hour! >= 1){
          if (numericDates){
            if abbreviation {
              return "1h ago"
            } else {
              return "1 hour ago"
            }
          } else {
            return "An hour ago"
          }
        } else if (components.minute! >= 2) {
          if abbreviation {
            return "\(components.minute!)m ago"
          } else {
            return "\(components.minute!) minutes ago"
          }
        } else if (components.minute! >= 1){
          return "Just now"
        } else if (components.second! >= 3) {
          return "Just now"
        } else {
          return "Just now"
        }
      }
      return convertedTime
    }

    public func convertUTCToLocal(_ format: String = "MM/dd/yyyy HH:mm:ss") -> String {
      if self.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        return "N/A"
      }
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      let testDate = dateFormatter.date(from: self)!
        
      let dateInLocal = testDate.addingTimeInterval(TimeInterval(TimeZone.getTimeZoneInSeconds()))
      return dateFormatter.string(from: dateInLocal)
    }
}

extension TimeZone {
  
  public static func getTimeZoneInHours() -> Int {
    return TimeZone.ReferenceType.local.secondsFromGMT() / 3600
  }
  
  public static func getTimeZoneInSeconds() -> Int {
    return TimeZone(secondsFromGMT:0)!.secondsFromGMT()
  }
}


extension UIViewController {
    func pushVC(_ vc: UIViewController){
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


extension UIView{
    
    func takeSnapshot(_ frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)

        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
    }
    
    func cirle() {
        self.setCornerRadius(self.frame.size.width/2)
    }
    
    func boderWith(_ color: CGColor, _ width: CGFloat) {
        self.layer.borderColor = color
        self.layer.borderWidth = width
    }
    
    func setCornerRadius(_ corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.clipsToBounds = true
    }
    
    func defaultConner() {
        self.setCornerRadius(DefaultSetting.defaultCornerRadius)
    }
    
    // SHADOW Left andd Bottom
    func LeftAndBottomShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // SHADOW Around
    func aroundShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
    
    func defaultShadow(){
        self.aroundShadow(color: .gray, opacity: 0.3, offSet: CGSize(width: 0.5, height: 0.5), radius: 8, scale: false)
    }
    
    func noShadow() {
        self.aroundShadow(color: .clear, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 0, scale: false)
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}

    



