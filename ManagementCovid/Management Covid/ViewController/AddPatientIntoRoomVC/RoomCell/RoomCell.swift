//
//  RoomCell.swift
//  Management Covid
//
//  Created by Mai Tài on 4/17/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit

class RoomCell: UICollectionViewCell {
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 5
    private var fillColor: UIColor = .white
    var shadowWidth: CGFloat = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func defaultUI() {
        vContainer.layer.cornerRadius = cornerRadius
        fillCellHightLight(1, .black, .white)
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
        lblName.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        lblName.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        lblTotal.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        lblTotal.font = UIFont(name: "Montserrat-Regular", size: 12)
        lblCount.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        lblCount.font = UIFont(name: "Montserrat-Regular", size: 12)
    }
    func fillUI(_ room: String,_ total: Int,_ count: Int){
        lblName.text = "Phòng \(room)"
        lblTotal.text = "Tổng giường: \(total)"
        lblCount.text = "Trống: \(count)"
    }
    func fillCellHightLight(_ borderWidth: CGFloat,_ borderColor: UIColor,_ backgroundColor: UIColor){
        vContainer.layer.borderWidth = borderWidth
        vContainer.layer.borderColor = borderColor.cgColor
        vContainer.backgroundColor = backgroundColor
    }

}
