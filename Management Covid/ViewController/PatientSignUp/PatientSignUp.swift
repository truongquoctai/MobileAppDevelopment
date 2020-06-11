//
//  PatientSignUp.swift
//  Management Covid
//
//  Created by Mai Tài on 4/6/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PatientSignUp: BaseVC,BaseButtonDelegate {
    
    //MARK: - Variable
    @IBOutlet weak var scvScroll: UIScrollView!
    @IBOutlet weak var vTouch: UIView!
    @IBOutlet weak var bName: TextFieldBaseView!
    @IBOutlet weak var bNgaySinh: TextFieldBaseView!
    @IBOutlet weak var bSex: TextFieldBaseView!
    @IBOutlet weak var bPlace: TextFieldBaseView!
    @IBOutlet weak var bSDT: TextFieldBaseView!
    @IBOutlet weak var vEmail: TextFieldBaseView!
    @IBOutlet weak var bCMND: TextFieldBaseView!
    @IBOutlet weak var vRegister: BaseButton!
    var currentBase: TextFieldBaseView?
    var arrBV: [TextFieldBaseView] = []
    var keyboardSize: CGRect?
    
    //MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        vRegister.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))
        vRegister.setCornerRadius(5)
        vRegister.layer.borderWidth = 1.5
        vRegister.layer.borderColor = UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1).cgColor
        vRegister.setTitle("Đăng Kí",UIFont(name: "Montserrat", size: 18)!, .white)
        vRegister.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))
        bSDT.txfInput.keyboardType = .numberPad
        vEmail.txfInput.keyboardType = .emailAddress
    }
    func createPatient(){
        bName.txfInput.text = "Bệnh nhân"
        bCMND.txfInput.text = "000000001"
        bNgaySinh.txfInput.text = "01/01/1990"
        bSex.txfInput.text = "1"
        bPlace.txfInput.text = "TP Hồ Chí Minh"
        bSDT.txfInput.text = "0987654321"
        vEmail.txfInput.text = "BenhNhan@gmail.com"
    }
    
    override func initData() {
        vRegister.delegate = self
        self.bName.delegate = self
        self.bNgaySinh.delegate = self
        self.bSex.delegate = self
        self.bPlace.delegate = self
        self.bSDT.delegate = self
        self.vEmail.delegate = self
        self.bCMND.delegate = self
        arrBV = [bName,bCMND,bNgaySinh,bSex,bPlace,bSDT,vEmail]
        hideKeyboard()
//        createPatient()
    }
    
    //MARK: - BaseButtonDelegate
        /*
         Name : clickButton
         Author : TRUONG QUOC TAI
         Discription : Gửi thông tin lên Server kiểm tra
         */
    func touchButton(view: UIView, button: UIButton) {
        self.CheckInput(view: bName, title: "Bạn nhập thiếu họ tên!")
        self.CheckInput(view: bCMND, title: "Bạn nhập thiếu số CMND/VISA!")
        self.CheckInput(view: bNgaySinh, title: "Bạn nhập thiếu mã ngày sinh!")
        self.CheckInput(view: bSex, title: "Bạn nhập thiếu giới tính!")
        self.CheckInput(view: bPlace, title: "Bạn nhập thiếu địa chỉ!")
        self.CheckInput(view: bSDT, title: "Bạn nhập thiếu số điện thoại!")
        self.CheckInput(view: vEmail, title: "Bạn nhập thiếu địa chỉ email!")
        
        var flag = true
        for base in arrBV{
            if base.txfInput.text == "" || base.txfInput.text == nil{
                flag = false
            }
        }
        if flag{
            let params:[String:Any] = ["fullName":bName.txfInput.text!,
                                         "identityCard":bCMND.txfInput.text!,
                                         "dateOfBirth":bNgaySinh.txfInput.text!,
                                         "gender":bSex.txfInput.text!,
                                         "phoneNumber":bSDT.txfInput.text!,
                                         "address":bPlace.txfInput.text!,
                                         "email":vEmail.txfInput.text!,
                                         "password":"123456"]
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            let headers :HTTPHeaders = ["Authorization":token]
            SVProgressHUD.show(withStatus: "Loading ...")
            SVProgressHUD.setDefaultMaskType(.clear)
            RequestManager.share.sentRequestWithHeaderAndBody(URLs.urlCreatePatient, .post, params, headers) { (response) in
                SVProgressHUD.dismiss()
                if(response.response?.statusCode == 404){
                    Utilities.share.alertNotification("Thông báo", "Lỗi kết nối tới máy chủ, vui lòng kiểm tra lại kết nối internet", "OK", self)
                    return
                }
                if(response.response?.statusCode == 500){
                    Utilities.share.alertNotification("Thông báo", "Tài khoản đã tồn tại. Vui lòng kiểm tra kĩ các thông tin đã nhập", "OK", self)
                    return
                }
                switch response.result{
                case .success(_):
                    do {
                        let data = JSON(response.value!)
                        let user = try JSONDecoder().decode(UserModal.self, from: data["result"].rawData())
                        debugPrint(user)
                        let vc = AddPatientIntoRoomVC(nibName: String(describing: AddPatientIntoRoomVC.self), bundle: nil)
                        vc.patientName = self.bName.txfInput.text ?? ""
                        vc.patientId = user._id ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    } catch let err {
                        debugPrint(err)
                    }
                    return
                case .failure(let err):
                    debugPrint(err)
                }
                
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
}
extension PatientSignUp: TextFieldBaseViewDelegate{
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
            bNgaySinh.setAnnounce("")
            bSex.setAnnounce("")
            bPlace.setAnnounce("")
            bSDT.setAnnounce("")
            vEmail.setAnnounce("")
            bCMND.setAnnounce("")
            break
        case bCMND:
            self.CheckInput(view: bName, title: "Bạn nhập thiếu họ tên!")
            break
        case bNgaySinh:
            self.CheckInput(view: bCMND, title: "Bạn nhập thiếu số CMND/VISA!")
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
