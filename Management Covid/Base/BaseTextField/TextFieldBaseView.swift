//
//  TextFieldBaseView.swift
//  CusApp
//
//  Created by Dang Nhat Duy on 10/31/19.
//  Copyright © 2019 crosstech. All rights reserved.
//

import UIKit
protocol TextFieldBaseViewDelegate {
    func beginEditingText(_ view: TextFieldBaseView, _ textfield: UITextField)
    func beginFloating(_ view: TextFieldBaseView, _ textfield: UITextField)
    func endFloating(_ view: TextFieldBaseView, _ textfield: UITextField)
    func endEditingText(_ view: TextFieldBaseView, _ textfield: UITextField)
}

@IBDesignable
class TextFieldBaseView: UIView, UITextFieldDelegate {
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txfInput: UITextField!
    @IBOutlet weak var vLine: UIView!
    @IBOutlet weak var lblAnnounce: UILabel!
    
    
    
    
    var delegate: TextFieldBaseViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.defaultInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.defaultInit()
    }
    
    func defaultInit() {
        let bundle = Bundle(for: TextFieldBaseView.self)
        bundle.loadNibNamed("TextFieldBaseView", owner: self, options: nil)
        self.vContainer.fixInView(self)
        self.initUI()
        self.txfInput.delegate = self
        
    }
    
    func initUI() {
        self.lblTitle.textColor = Color.titleText
        self.lblTitle.font = UIFont(name: "Montserrat", size: 8)
        
        self.txfInput.textColor = Color.textColor
        self.txfInput.font = UIFont(name: "Montserrat", size: 14)
        
        self.vLine.backgroundColor = Color.textColor
        
        self.lblTitle.isHidden = true
        
        self.lblAnnounce.textColor = Color.underAnnounce
        self.lblAnnounce.font = UIFont(name: "Montserrat", size: 10)
        self.lblAnnounce.text = ""
    }
    
    func setSecureTextEntry(_ check: Bool) {
        self.txfInput.isSecureTextEntry = check
        if #available(iOS 12, *) {
            self.txfInput.textContentType = .oneTimeCode
        } else {
            self.txfInput.textContentType = .none
        }
    }
    
    private var _textPlaceHolder: String = ""
    @IBInspectable
    var textPlaceHolder : String {
        set(newValue) {
            _textPlaceHolder = newValue
            self.txfInput.placeholder = _textPlaceHolder
        }
        get {
            return _textPlaceHolder
        }
    }
    
    private var _textTitle: String = ""
    @IBInspectable
    var textTitle : String {
        set(newValue) {
            _textTitle = newValue
            self.lblTitle.text = _textTitle
        }
        get {
            return _textTitle
        }
    }
    
    func setAnnounce(_ text: String) {
        self.lblAnnounce.text = text
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.beginEditingText(self, textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.endEditingText(self, textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 1 && string == "" {
            self.delegate?.endFloating(self, textField)
        }
        else {
            self.delegate?.beginFloating(self, textField)
        }
        return true
    }
    

    /*
     Name : Disign
     Author : Bui Cuong
     Discription : Hàm định đạng
     */
    //Montserrat
    func designTexfieldBaseView( title : String, text : String,  bold : Bool){
        
        //lblTitle
        self.lblTitle.text = title
        self.lblTitle.textColor = Color.titleText
        self.lblTitle.font = UIFont(name: Font.text, size: DefaultSetting.sizeTitle11)
        if(bold == true){
            self.lblTitle.textColor = Color.black
            self.lblTitle.font =  DefaultSetting.boldSystemFont18
        }
        
        //lbltxfInput
        self.txfInput.text = text
        self.txfInput.textColor = Color.textColor
        self.txfInput.font = UIFont(name: Font.text, size: DefaultSetting.sizeText14)
        
        if(bold != true){
            self.txfInput.placeholder = title
        }
        
        //vLine
        self.vLine.backgroundColor = Color.lineColor
    }
}
