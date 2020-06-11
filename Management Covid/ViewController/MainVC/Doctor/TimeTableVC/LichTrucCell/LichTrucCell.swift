//
//  LichTrucCell.swift
//  Management Covid
//
//  Created by Mai Tài on 4/15/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit

class LichTrucCell: UITableViewCell {
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblTimeTruc: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 5
    private var fillColor: UIColor = .white
    var shadowWidth: CGFloat = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
        fillUI()
    }

    func fillUI(){
        vContainer.layer.cornerRadius = cornerRadius
        vContainer.clipsToBounds = false
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shadowWidth , height: vContainer.bounds.height), cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            vContainer.layer.insertSublayer(shadowLayer, at: 0)
        }
        lblTimeTruc.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        lblTimeTruc.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        lblDes.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        lblDes.font = UIFont(name: "Montserrat-Regular", size: 12)
    }
    func fillData(_ ngayTruc: String,_ gioTruc: String){
        lblTimeTruc.text = ngayTruc
        lblDes.text = gioTruc
    }
    
}
