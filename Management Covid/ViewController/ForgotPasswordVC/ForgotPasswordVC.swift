//
//  ForgotPasswordVC.swift
//  Management Covid
//
//  Created by Mai Tài on 5/25/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import SwiftyJSON

class ForgotPasswordVC: BaseVC {
    @IBOutlet weak var scvScroll: UIScrollView!
    @IBOutlet weak var bNavigationBar: BaseNavigationBar!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var bInput: TextFieldBaseView!
    @IBOutlet weak var bButton: BaseButton!
    
    var keyboardSize: CGRect?
    var currentBase: TextFieldBaseView?
    var arrBV: [TextFieldBaseView] = []
    var text = "Nhập Email"
    var email = ""
    var descriptionLbl = "Nhập đúng Email bạn đã đăng kí. Mã xác nhận sẽ được gửi về mail của bạn."
    var titleInput = "Email"
    var titleButton = "Gửi Mã"
    var confirmCode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bInput.delegate = self
        bButton.delegate = self
        bNavigationBar.dele = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    override func initUI() {
        bNavigationBar.setNavigate("Back", "", "")
        lblTitle.text = text
        lblDescription.text = descriptionLbl
        bButton.setTitle(titleButton, UIFont(name: Font.text, size: 18)!, .white)
        bButton.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))
        
        bInput.designTexfieldBaseView(title: titleInput, text: "", bold: false)
    }
    
    @objc func keyboardChange(_ notification: NSNotification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let size = self.view.convert(keyboardSize, from: nil)
            if self.keyboardSize != nil {
                if size.origin.y != UIScreen.main.bounds.size.height {
                    self.keyboardSize = size
                }
            }
            else {
                if self.currentBase != nil {
                    if size.origin.y != UIScreen.main.bounds.size.height {
                        self.keyboardSize = size
                    }
                }
            }
        }
    }
    
    /*
     Name : CheckInput
     Author : TRUONG QUOC TAI
     Discription : Thông báo tới người dùng title nếu view chứa textfile rỗng
     */
    func CheckInput(view: TextFieldBaseView,title: String) -> Bool{
        if(view.txfInput.text == ""){
            view.setAnnounce(title)
            return false
        }else{
            view.setAnnounce("")
            return true
        }
    }

}
extension ForgotPasswordVC: TextFieldBaseViewDelegate {
    func beginEditingText(_ view: TextFieldBaseView, _ textfield: UITextField) {
        
        self.currentBase = view
        if self.keyboardSize != nil {
            let positionTextField: CGFloat = (view.frame.origin.y) + (view.frame.size.height) + 20
            let positionKeyboard: CGFloat = (self.keyboardSize?.origin.y)! - (view.frame.size.height)
            
            if positionTextField > positionKeyboard {
                self.scvScroll.contentOffset = CGPoint(x: 0, y: positionTextField - positionKeyboard)
            }
        }
    }
    
    func endEditingText(_ view: TextFieldBaseView, _ textfield: UITextField) {
        var check = false
        for base: TextFieldBaseView in arrBV {
            if base.txfInput.text == "" {
                check = true
                base.txfInput.becomeFirstResponder()
                break
            }
        }
        if check == false {
            view.txfInput.resignFirstResponder()
            self.scvScroll.contentOffset = .zero
        }
    }
    
    func beginFloating(_ view: TextFieldBaseView, _ textfield: UITextField) {
        view.lblTitle.isHidden = false
    }

    func endFloating(_ view: TextFieldBaseView, _ textfield: UITextField) {
        view.lblTitle.isHidden = true
    }
    
    
}

extension ForgotPasswordVC: BaseButtonDelegate {
    func touchButton(view: UIView, button: UIButton) {
        
        
        if !CheckInput(view: bInput, title: "Email không được để trống") {
            return
        }
        if confirmCode { //enterCode and checkcode
            let params: [String: Any] = ["email": email,
                                         "code": bInput.txfInput.text!]
            SVProgressHUD.show(withStatus: "Sending...")
            RequestManager.share.sentRequestWithBody(URLs.urlCheckCode, .post, params) { (response) in
                SVProgressHUD.dismiss()

                if(response.response?.statusCode == 200) {
                    self.gotoNewPasswordVC()
                    return
                }

                if(response.response?.statusCode == 404 || response.response?.statusCode == nil){
                    Utilities.share.alertNotification("Thông báo", "Mã xác minh không hợp lệ.", "OK", self)
                    return
                }
                let value = JSON(response.value!)
                let m = value["message"]
                Utilities.share.alertNotification("Thông báo", "\(m)", "OK", self)
            }
        } else { //enter Email and check email
            let params: [String: Any] = ["email": bInput.txfInput.text!]
            SVProgressHUD.show(withStatus: "Sending...")
            RequestManager.share.sentRequestWithBody(URLs.urlSentCode, .post, params) { (response) in
                SVProgressHUD.dismiss()
                if(response.response?.statusCode == 404 || response.response?.statusCode == nil){
                    Utilities.share.alertNotification("Thông báo", "Email bạn nhập không tồn tại.", "OK", self)
                    return
                }
                if(response.response?.statusCode == 200) {
                    Utilities.share.alertShowNotification("Thông báo", "Mã xác minh đã được gửi về hòm thư của bạn.", "OK", self) { (_) in
                        self.gotoCheckCodeVC()
                    }
                    return
                }
                let data = JSON(response.value!)
                let message = data["message"]
                Utilities.share.alertNotification("Thông báo", "\(message)", "OK", self)
                return
            }
        }
    }
    
    func gotoCheckCodeVC(){
        let vc = ForgotPasswordVC(nibName: String(describing: ForgotPasswordVC.self) , bundle: nil)
        vc.text = "Nhập mã xác minh"
        vc.titleInput = "Mã xác minh"
        vc.titleButton = "Xác nhận"
        vc.descriptionLbl = "Kiểm tra mã xác minh trong hòm thư của bạn."
        vc.email = bInput.txfInput.text!
        vc.confirmCode = true
        pushVC(vc)
    }
    
    func gotoNewPasswordVC(){
        let vc = ChangePassVC(nibName: String(describing: ChangePassVC.self), bundle: nil)
        vc.isForgotPass = true
        vc.email = email
        pushVC(vc)
    }
    
}
extension ForgotPasswordVC: BaseNavigationBarDelegate {
    func clickButtonBack(_ view: UIView, _ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func clickButtonIcon(_ view: UIView, _ button: UIButton) {
        
    }
    
    
}
