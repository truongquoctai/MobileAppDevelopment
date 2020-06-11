//
//  HistoryCell.swift
//  CusApp
//
//  Created by Trương Quốc Tài on 11/17/19.
//  Copyright © 2019 crosstech. All rights reserved.
//

import UIKit
import SwipeCellKit
import SDWebImage

class PatientCell: SwipeTableViewCell {
    @IBOutlet weak var imgClassAvatar: UIImageView!
    @IBOutlet weak var imgChekin: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRoom: UILabel!
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 5
    private var fillColor: UIColor = .white
    var shadowWidth: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initUI(clShadow: UIColor){
        imgChekin.isHidden = true
        vContainer.layer.cornerRadius = cornerRadius
        vContainer.clipsToBounds = false
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shadowWidth , height: vContainer.bounds.height), cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            shadowLayer.shadowColor = clShadow.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            vContainer.layer.insertSublayer(shadowLayer, at: 0)
        }
        imgClassAvatar.layer.cornerRadius = imgClassAvatar.frame.height/2
        lblName.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        lblName.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        lblTime.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        lblTime.font = UIFont(name: "Montserrat-Regular", size: 12)
        lblRoom.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        lblRoom.font = UIFont(name: "Montserrat-Regular", size: 12)
    }
    
    func fillData(_ fullName: String,_ dateOfBirth: String,_ phoneNumber:String,_ imgAvatar: String, dateCreate: Int? = 0){
        var textName = "\(fullName)"
        if let dateCreate = dateCreate {
            if dateCreate != 0 {
//                let myTimeStamp = Date().currentTimeMillis()
//                let numDate = (Int(myTimeStamp) - dateCreate)/8640000
//                textName += " | \(numDate) ngày"
                textName += " | \(Utilities.share.getDays(dateCreate))"
            }
        }
        
        lblName.text = "\(textName) "
        lblTime.text = "Ngày sinh:\(dateOfBirth)"
        lblRoom.text = "SĐT: \(phoneNumber)"
        imgClassAvatar.image = UIImage(named: "UserDefault")
        if imgAvatar != "" {
            let strURLAvatar = "\(URLs.host)/\(imgAvatar)"
            let url = URL(string: strURLAvatar)
            imgClassAvatar.sd_setImage(with: url)
        }
    }
    
    func setChecked(){
        imgChekin.isHidden = false
    }
    
    func setDidChecked() {
        imgChekin.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
}

