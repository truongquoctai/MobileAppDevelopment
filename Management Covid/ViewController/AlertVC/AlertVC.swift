//
//  AlertVC.swift
//  CusApp
//
//  Created by Trương Quốc Tài on 12/1/19.
//  Copyright © 2019 crosstech. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class AlertVC: BaseVC {
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var vButton: BaseButton!
    var numOfIsolationDay: Int64 = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vBackground.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vBackground.isHidden = true
    }
    
    override func initUI() {
        vContainer.layer.borderWidth = 0.1
        vContainer.layer.borderColor = UIColor.white.cgColor
        vContainer.layer.cornerRadius = 15
        lblTitle.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        lblTitle.font = UIFont(name: "Montserrat-SemiBold", size: 15)
        
        vButton.setBGColor(UIColor(red: 0.482, green: 0.769, blue: 0.408, alpha: 1))
        vButton.vContainer.layer.cornerRadius = 5
        imgAvatar.loadGif(asset: "congratulations")
    }
    
    override func initData() {
        vButton.delegate = self
        view.backgroundColor = .clear
        view.isOpaque = false
        
    }
    
    func fillUI(){
        lblTitle.text = "Chúc mừng bạn đã cách ly được \(numOfIsolationDay) ngày!"
        vButton.setTitle("OK", UIFont(name: "Montserrat-SemiBold", size: 14)!, .white)
    }
    
}

extension AlertVC: BaseButtonDelegate {
    func touchButton(view: UIView, button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
