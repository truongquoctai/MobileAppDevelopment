//
//  ChoiseVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/5/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ChoiseVC: BaseVC {
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var vChoise: UIView!
    @IBOutlet weak var imgLoadGif: UIImageView!
    @IBOutlet weak var btnDoctor: UIButton!
    @IBOutlet weak var btnPatient: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    override func initData() {
        
    }
    @IBAction func onBtnDoctor(_ sender: Any) {
        let vc = RegisterVC(nibName: String(describing: RegisterVC.self) , bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBtnPatient(_ sender: Any) {
        let vc = LoginVC(nibName: String(describing: LoginVC.self) , bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onbtnLogin(_ sender: Any) {
        let vc = LoginVC(nibName: String(describing: LoginVC.self) , bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
