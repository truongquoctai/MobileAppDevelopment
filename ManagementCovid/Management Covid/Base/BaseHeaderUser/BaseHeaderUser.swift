//
//  BaseHeaderUser.swift
//  CityGuideApp
//
//  Created by Chanh Dat Ng on 8/16/19.
//  Copyright © 2019 Chanh Dat Ng. All rights reserved.
//

import UIKit

protocol BaseHeaderUserDelegate {
    func saveData()
}
@IBDesignable
class BaseHeaderUser: UIView, UITextFieldDelegate {


    // MARK: - Variable
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var vBG: UIView!
    @IBOutlet weak var vAva: UIView!
    @IBOutlet weak var imvAva: UIImageView!
    @IBOutlet weak var txfBio: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    @IBOutlet weak var txfDoB: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    
    var dele: BaseHeaderUserDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.defaultInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.defaultInit()
    }
    

    func defaultInit() {
        let bundle = Bundle(for: BaseHeaderUser.self)
        bundle.loadNibNamed("BaseHeaderUser", owner: self, options: nil)
        self.vContainer.fixInView(self)
        self.imvAva.layer.cornerRadius = self.self.imvAva.frame.width/2
        self.vAva.backgroundColor = UIColor.clear
    
        
        self.vBG.layer.masksToBounds = false
        self.vBG.layer.cornerRadius = 60
        self.txfBio.delegate = self
        self.txfEmail.delegate = self
        self.txfPhone.delegate = self
        self.txfDoB.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.autocorrectionType = .no
        return true
    }
    @IBAction func onBtnSave(_ sender: Any) {
        self.dele?.saveData()
    }
}
