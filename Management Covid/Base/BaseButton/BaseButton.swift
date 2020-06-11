//
//  BaseButton.swift
//  Management Covid
//
//  Created by Mai Tài on 4/6/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
protocol BaseButtonDelegate {
    func touchButton(view: UIView, button: UIButton)
}
@IBDesignable
class BaseButton: UIView {

    

    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btnButton:UIButton!
    var delegate: BaseButtonDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        defaultInit()
    }
    
    func defaultInit(){
        let bundle = Bundle(for: BaseButton.self)
        bundle.loadNibNamed("BaseButton", owner: self, options: nil)
        self.vContainer.fixInView(self)
    }
    func setTitle(_ titleButton: String,_ font: UIFont,_ titleColor:UIColor){
        btnButton.setTitle(titleButton, for: .normal)
        btnButton.titleLabel?.font = font
        btnButton.setTitleColor(titleColor, for: .normal)
    }
    
    @IBAction func onBtnButton(sender: Any){
        delegate?.touchButton(view: self, button: btnButton)
    }

    func setBGColor(_ color: UIColor){
        self.vContainer.backgroundColor = color
    }
}
