//
//  ChangePassVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/14/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import Alamofire

class ChangePassVC: BaseVC,BaseButtonDelegate {
    @IBOutlet weak var scvScroll: UIScrollView!
    @IBOutlet weak var vTouch: UIView!
    @IBOutlet weak var bOldPassword: TextFieldBaseView!
    @IBOutlet weak var bConfirmPass: TextFieldBaseView!
    @IBOutlet weak var bPassword: TextFieldBaseView!
    @IBOutlet weak var bButton: BaseButton!
    @IBOutlet weak var vTop: UIView!
    
    
    var keyboardSize: CGRect?
    var currentBase: TextFieldBaseView?
    var arrBV: [TextFieldBaseView] = []
    var oldPass = ""
    var email = ""
    var isForgotPass = false
    var delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func initUI() {
        bOldPassword.designTexfieldBaseView(title: "Mật khẩu cũ", text: "\(oldPass)", bold: false)
        
        bPassword.txfInput.isSecureTextEntry = true
        bConfirmPass.txfInput.isSecureTextEntry = true
        
        bButton.setTitle("Xác nhận", UIFont(name: Font.text, size: 18)!, .white)
        bButton.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))
        
        if isForgotPass {
            bOldPassword.designTexfieldBaseView(title: "Email", text: email, bold: false)
            vTop.isHidden = false
            return
        }
        vTop.isHidden = true
        initNaviBar()
    }
    
    override func initData() {
        bButton.delegate = self
        bPassword.delegate = self
        bConfirmPass.delegate = self
        bOldPassword.delegate = self
        arrBV = [bOldPassword,bPassword,bConfirmPass]
    }
    
    private func initNaviBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        titleNavibar(text: "Đổi mật khẩu")
        
        //init left button
        
    }
    
    func titleNavibar(text: String) {
        navigationItem.title = text
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .font : DefaultSetting.boldSystemFont18
        ]
        navigationController?.navigationBar.titleTextAttributes =  strokeTextAttributes
    }
    
    @IBAction func onBtnback(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    Name : touchButton
    Author : TRUONG QUOC TAI
    Discription :
     - Kiểm tra nếu oldPass != "" thì là lần đăng nhập đầu tiên của patient-> chuyển qua màn hình CreateAvatarVC
     - Nếu không phải thì chuyển về màn hình setting của user(Doctor or Patient)
    */
    func touchButton(view: UIView, button: UIButton) {
        self.CheckInput(view: bPassword, title: "Nhập mật khẩu cũ của bạn!")
        self.CheckInput(view: bPassword, title: "Mật khẩu không được để trống!")
        self.CheckInput(view: bConfirmPass, title: "Mật khẩu không trùng nhau!")
        
        for base in arrBV{
            if base.txfInput.text == "" || base.txfInput.text == nil{
                return
            }
        }
        if(bPassword.txfInput.text != bConfirmPass.txfInput.text){
            Utilities.share.alertNotification("Thông báo", "Mật khẩu không trùng nhau", "OK", self)
            return
        }
        if(bPassword.txfInput.text == "123456"){
            Utilities.share.alertNotification("Thông báo", "Không được để mật khẩu mặc định", "OK", self)
            return
        }
        if isForgotPass {
            forgotPassword()
        } else {
            changePassword()
        }
    }
    
    func forgotPassword(){
        let params:[String:Any] = ["email":email,
        "password":bConfirmPass.txfInput.text!]
        SVProgressHUD.show(withStatus: "Loading...")
        RequestManager.share.sentRequestWithBody(URLs.urlForgotPass, .put, params) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 200){
                Utilities.share.alertShowNotification("Thông báo", "Đổi mật khẩu thành công", "OK", self) { (_) in
                    UserDefaults.standard.set(self.bPassword.txfInput.text!, forKey: "password")
                    let vc = self.delegate.navigation.viewControllers[1]
                    self.navigationController?.popToViewController(vc, animated: true)
                }
                return
            }
            if(response.response?.statusCode == 404){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet", "OK", self)
                return
            }
            
        }
        
    }
    
    func changePassword(){
        let params:[String:Any] = ["newPassword":bPassword.txfInput.text!,
                                   "againNewPassword":bConfirmPass.txfInput.text!]
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers:HTTPHeaders = ["Authorization": token]
        SVProgressHUD.show(withStatus: "Loading...")
        RequestManager.share.sentRequestWithHeaderAndBody(URLs.urlChangePass, .put, params, headers) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet", "OK", self)
                return
            }
            if(response.response?.statusCode == 200){
                Utilities.share.alertShowNotification("Thông báo", "Đổi mật khẩu thành công", "OK", self) { (_) in
                    UserDefaults.standard.set(self.bPassword.txfInput.text!, forKey: "password")
                    if(self.oldPass != ""){
                        let vc = CreateAvatarVC(nibName: String(describing: CreateAvatarVC.self), bundle: nil)
                        vc.isDoctor = false
                        self.pushVC(vc)
                    }
                    else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                return
            }
        }
    }
    
    /*
     Name : CheckInput
     Author : TRUONG QUOC TAI
     Discription : Thông báo tới người dùng title nếu view chứa textfile rỗng
     */
    func CheckInput(view: TextFieldBaseView,title: String){
        if(view.txfInput.text == ""){
            view.setAnnounce(title)
        }else{
            view.setAnnounce("")
        }
    }
}

//MARK: - extension TextFieldBaseViewDelegate
extension ChangePassVC: TextFieldBaseViewDelegate{
    /*
     Name : beginEditingText
     Author : TRUONG QUOC TAI
     Discription : Lúc bấm vào 1 textfield(TF) nào thì ktra điều kiện các TF ở phía trên nó
     //[bName,bCMND,bNgaySinh,bSex,bPlace,bSDT,vEmail,bPassword,bConfirmPassword]
     */
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
