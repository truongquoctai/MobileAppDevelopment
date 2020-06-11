//
//  Contrains.swift
//  Management Covid
//
//  Created by Mai Tài on 3/27/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import Foundation
import  UIKit
struct VCName {
    static let LoginVC = "LoginVC"
    static let ForgotPasswordVC = "ForgotPasswordVC"
    
}

struct SBName {
    static let mainStoryboard = "Main"
}
struct Color {
    static let white = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) //màu trắng
    static let black = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) //màu đen
    static let titleText = UIColor(red: 0.565, green: 0.565, blue: 0.565, alpha: 0.85) //màu đen nhạt
    static let lineColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 0.85) //màu đen
    static let textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 0.85) //màu đen
    static let btnBGColor = UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1) //màu xanh chuối
    static let underAnnounce = UIColor(red: 0.961, green: 0.302, blue: 0.267, alpha: 1) //màu đỏ
    static let bGAvata = UIColor(red: 0.953, green: 0.953, blue: 0.953, alpha: 1) //màu xám nhạt
    static let iconAvata = UIColor(red: 0.773, green: 0.773, blue: 0.773, alpha: 1) //màu xám đậm
    static let blurColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6) //màu đen + opacity
    
    //gradient: đỏ
    static let beginColor = UIColor(red: 0.967, green: 0.499, blue: 0.471, alpha: 1).cgColor
    static let endColor = UIColor(red: 0.954, green: 0.216, blue: 0.179, alpha: 1).cgColor
}


struct Font {
    static let text = "Montserrat"
}
struct DefaultSetting {
    static let defaultCornerRadius: CGFloat     = 5.0
    static let boldSystemFont18 = UIFont.boldSystemFont(ofSize: 18)
    static let boldSystemFont15 = UIFont.boldSystemFont(ofSize: 15)
    static let size18 = CGFloat(18.0)
    static let size15 = CGFloat(15.0)
    static let sizeText14 = CGFloat(14.0)
    static let sizeTitle11 = CGFloat(11.0)
}
