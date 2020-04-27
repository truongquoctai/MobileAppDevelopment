//
//  RegisterVC.swift
//  CusApp
//
//  Created by VN Poly on 29/10/2019.
//  Copyright © 2019 crosstech. All rights reserved.
//

import UIKit
import SwiftyJSON
import JWTDecode

class RegisterVC: BaseVC,UINavigationControllerDelegate {
    //MARK: - Variable
    @IBOutlet weak var scvScroll: UIScrollView!
    @IBOutlet weak var vTouch: UIView!
    @IBOutlet weak var vRegister: BaseButton!
    @IBOutlet weak var vNavigation: BaseNavigationBar!
    @IBOutlet weak var bName: TextFieldBaseView!
    @IBOutlet weak var bCMND: TextFieldBaseView!
    @IBOutlet weak var bNgaySinh: TextFieldBaseView!
    @IBOutlet weak var bSex: TextFieldBaseView!
    @IBOutlet weak var bPlace: TextFieldBaseView!
    @IBOutlet weak var bSDT: TextFieldBaseView!
    @IBOutlet weak var vEmail: TextFieldBaseView!
    @IBOutlet weak var bPassword: TextFieldBaseView!
    @IBOutlet weak var bConfirmPassword: TextFieldBaseView!
    
    var currentBase: TextFieldBaseView?
    var arrBV: [TextFieldBaseView] = []
    var keyboardSize: CGRect?
    var newUser: UserModal = UserModal()
    
    // MARK: - Cirle Life
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
        vNavigation.btnIcon.isHidden = true
        vNavigation.lblTitle.isHidden = true
        vNavigation.btnBack.setImage(UIImage(named: "Back"), for: .normal)
//        vAvatar.layer.cornerRadius = vAvatar.bounds.width/2
//        btnAvatar.layer.cornerRadius = btnAvatar.bounds.width/2
        vRegister.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))
        vRegister.setCornerRadius(5)
        vRegister.layer.borderWidth = 1.5
        vRegister.layer.borderColor = UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1).cgColor
        vRegister.setTitle("Đăng Kí",UIFont(name: "Montserrat", size: 18)!, .white)
        vRegister.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))
//        btnAvatar.clipsToBounds = true
        
        //base texfield
        bPassword.txfInput.isSecureTextEntry = true
        bConfirmPassword.txfInput.isSecureTextEntry = true
        
        dataTest()
    }
    func dataTest(){
        bName.txfInput.text = "Truong Quoc Tai"
        bCMND.txfInput.text = "184261922"
        bNgaySinh.txfInput.text = "20/04/1998"
        bSex.txfInput.text = "1"
        bPlace.txfInput.text = "Ha Tinh"
        bSDT.txfInput.text = "0364124747"
        vEmail.txfInput.text = "truongquoctai0498@gmail.com"
        bPassword.txfInput.text = "A123456789"
        bConfirmPassword.txfInput.text = "A123456789"
    }
    
    override func initData() {
        vNavigation.dele = self
        vRegister.delegate = self
        self.bName.delegate = self
        self.bCMND.delegate = self
        self.bNgaySinh.delegate = self
        self.bSex.delegate = self
        self.bPlace.delegate = self
        self.bSDT.delegate = self
        self.vEmail.delegate = self
        self.bPassword.delegate = self
        self.bConfirmPassword.delegate = self
        arrBV = [bName,bCMND,bNgaySinh,bSex,bPlace,bSDT,vEmail,bPassword,bConfirmPassword]
        hideKeyboard()
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
    
    func sentRequestLogin(_ CMND: String,_ password: String){
        SVProgressHUD.show(withStatus: "Loading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        let params: [String:Any] = ["identityCard":CMND,
                                    "password": password]
        RequestManager.share.sentRequestWithBody(URLs.urlLogin, .post, params) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối mạng", "OK", self)
                return
            }
            if(response.response?.statusCode == 401){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại số CMND hoặc mật khẩu", "OK", self)
                return
            }
            if(response.response?.statusCode == 200){
                switch response.result{
                case .success(_):
                    let data = JSON(response.value!)
                    let token = data["token"].string ?? ""
                    UserDefaults.standard.set(token, forKey: "token")
                    let vc = CreateAvatarVC(nibName: String(describing: CreateAvatarVC.self), bundle: nil)
                    vc.isDoctor = true
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let err):
                    debugPrint(err)
                    Utilities.share.alertShowNotification("Thông báo", "Tạo tài khoản thành công nhưng đăng nhập thất bại. Vui lòng đăng nhập lại", "OK", self) { (_) in
                    let vc = LoginVC(nibName: String(describing: LoginVC.self), bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                    return
                    
                }
            }
        }
    }
}

extension RegisterVC: BaseNavigationBarDelegate{
    func clickButtonIcon(_ view: UIView, _ button: UIButton) {
        
    }
    
    func clickButtonBack(_ view: UIView, _ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - BaseButtonDelegate
extension RegisterVC: BaseButtonDelegate{
    /*
     Name : clickButton
     Author : TRUONG QUOC TAI
     Discription : Gửi thông tin lên Server kiểm tra
     //check validate trong hàm này
     */
    func touchButton(view: UIView, button: UIButton) {
        
        self.CheckInput(view: bName, title: "Bạn nhập thiếu họ tên!")
        self.CheckInput(view: bCMND, title: "Bạn nhập thiếu số CMND!")
        self.CheckInput(view: bNgaySinh, title: "Bạn nhập thiếu mã ngày sinh!")
        self.CheckInput(view: bSex, title: "Bạn nhập thiếu giới tính!")
        self.CheckInput(view: bPlace, title: "Bạn nhập thiếu địa chỉ!")
        self.CheckInput(view: bSDT, title: "Bạn nhập thiếu số điện thoại!")
        self.CheckInput(view: vEmail, title: "Bạn nhập thiếu địa chỉ email!")
        self.CheckInput(view: bPassword, title: "Bạn nhập thiếu mật khẩu!")
        self.CheckInput(view: bConfirmPassword, title: "Vui lòng nhập lại mật khẩu!")
        if(bPassword.txfInput.text != bConfirmPassword.txfInput.text){
            bConfirmPassword.setAnnounce("Bạn nhập mật khẩu ko trùng nhau!")
        }
        if((Utilities.share.convertFromString(bNgaySinh.txfInput.text!)) == nil){
            bNgaySinh.setAnnounce("Ngày sinh bạn nhập không hợp lệ")
            return
        }
        for base in arrBV{
            if base.txfInput.text == "" || base.txfInput.text == nil{
                return
            }
        }
        newUser.fullName = bName.txfInput.text!
        newUser.identityCard = bCMND.txfInput.text!
        newUser.dateOfBirth = bNgaySinh.txfInput.text!
        newUser.gender = Int(bSex.txfInput.text!)
        newUser.address = bPlace.txfInput.text!
        newUser.phoneNumber = bSDT.txfInput.text!
        newUser.email = vEmail.txfInput.text!
        newUser.passWord = bPassword.txfInput.text!
        let params = ["fullName":newUser.fullName!,
                  "identityCard":newUser.identityCard!,
                  "dateOfBirth":newUser.dateOfBirth!,
                  "address": newUser.address!,
                  "phoneNumber":newUser.phoneNumber!,
                  "email":newUser.email!,
                  "password":newUser.passWord!]
        SVProgressHUD.show(withStatus: "Loading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        RequestManager.share.sentRequestWithBody(URLs.ulrCreateDoctor, .post, params) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet của bạn.", "OK", self)
                return
            }
            if(response.response?.statusCode == 500){
                Utilities.share.alertNotification("Thông báo", "Tài khoản đã tồn tại.", "OK", self)
                return
            }
            if(response.response?.statusCode == 200){
                switch response.result{
                case .success(_):
                    self.sentRequestLogin(self.newUser.identityCard!, self.newUser.passWord!)
                case .failure(let err):
                    Utilities.share.alertNotification("Thông báo", err.errorDescription ?? "", "OK", self)
                }
                return
            }
            Utilities.share.alertNotification("Thông báo", "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng kiểm tra lại kết nối internet của bạn.", "OK", self)
            return
            
        }
        
    }
}
extension RegisterVC: TextFieldBaseViewDelegate{
    /*
     Name : beginEditingText
     Author : TRUONG QUOC TAI
     Discription : Lúc bấm vào 1 textfield(TF) nào thì ktra điều kiện các TF ở phía trên nó
     //[bName,bCMND,bNgaySinh,bSex,bPlace,bSDT,vEmail,bPassword,bConfirmPassword]
     */
    func beginEditingText(_ view: TextFieldBaseView, _ textfield: UITextField) {
        switch view {
        case bName:
            bName.setAnnounce("")
            bCMND.setAnnounce("")
            bNgaySinh.setAnnounce("")
            bSex.setAnnounce("")
            bPlace.setAnnounce("")
            bSDT.setAnnounce("")
            vEmail.setAnnounce("")
            bPassword.setAnnounce("")
            bConfirmPassword.setAnnounce("")
            
            break
        case bCMND:
            self.CheckInput(view: bName, title: "Bạn nhập thiếu họ tên!")
            break
        case bNgaySinh:
            self.CheckInput(view: bCMND, title: "Bạn nhập thiếu số CMND!")
            break
        case bSex:
            self.CheckInput(view: bNgaySinh, title: "Bạn nhập thiếu ngày sinh!")
            break
        case bPlace:
            self.CheckInput(view: bSex, title: "Bạn nhập thiếu giới tính!")
            break
        case bSDT:
            self.CheckInput(view: bPlace, title: "Bạn nhập thiếu địa chỉ!")
            break
        case vEmail:
            self.CheckInput(view: bSDT, title: "Bạn nhập thiếu số điện thoại!")
            break
        case bPassword:
            self.CheckInput(view: vEmail, title: "Bạn nhập thiếu địa chỉ email!")
            break
        case bConfirmPassword:
            self.CheckInput(view: bPassword, title: "Bạn nhập thiếu password!")
            break
        default:
            break
        }
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


