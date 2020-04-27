    //
    //  ConfirmCMNDVC.swift
    //  Management Covid
    //
    //  Created by Mai Tài on 4/8/20.
    //  Copyright © 2020 Mai Tài. All rights reserved.
    //

    import UIKit
    import SwiftyJSON
    import JWTDecode

    class LoginVC: BaseVC,BaseButtonDelegate,BaseNavigationBarDelegate {


    @IBOutlet weak var scvScroll: UIScrollView!
    @IBOutlet weak var vTouch: UIView!
    @IBOutlet weak var bNavigationBar: BaseNavigationBar!
    @IBOutlet weak var bCMND: TextFieldBaseView!
    @IBOutlet weak var bPassword: TextFieldBaseView!
    @IBOutlet weak var bButton: BaseButton!
    var keyboardSize: CGRect?
    var currentBase: TextFieldBaseView?
    var arrBV: [TextFieldBaseView] = []
    
    override func viewWillAppear(_ animated: Bool) {
        let identityCard = UserDefaults.standard.string(forKey: "identityCard") ?? ""
        let password = UserDefaults.standard.string(forKey: "password") ?? ""
        bCMND.txfInput.text = identityCard
        bPassword.txfInput.text = password
    }
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
        bNavigationBar.setNavigate("Back", "", "")
        bButton.setTitle("Đăng nhập", UIFont(name: Font.text, size: 18)!, .white)
        bButton.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))
        bPassword.txfInput.isSecureTextEntry = true
    }
    override func initData() {
        bNavigationBar.dele = self
        bButton.delegate = self
        bCMND.delegate = self
        arrBV = [bCMND,bPassword]
        bCMND.txfInput.text = "184261922"
        bPassword.txfInput.text = "A123456789"
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
    func clickButtonBack(_ view: UIView, _ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    func clickButtonIcon(_ view: UIView, _ button: UIButton) {}

    //MARK: - Button Login
    func touchButton(view: UIView, button: UIButton) {
        self.CheckInput(view: bCMND, title: "Bạn nhập thiếu số CMND!")
        self.CheckInput(view: bPassword, title: "Mật khẩu không được để trống!")
        for base in arrBV{
            if base.txfInput.text == "" || base.txfInput.text == nil{
                return
            }
        }
        login(statusSV: "Loading ...")
    }
    func login(statusSV: String){
        //gửi yêu cầu login lên sv, nhận về
        SVProgressHUD.show(withStatus: statusSV)
        SVProgressHUD.setDefaultMaskType(.clear)
        let params: [String:Any] = ["identityCard":bCMND.txfInput.text!,
                                    "password": bPassword.txfInput.text!]
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
                    do {
                        let data = JSON(response.value!)
                        debugPrint(data)
                        let token = data["token"].string ?? ""
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(self.bCMND.txfInput.text!, forKey: "identityCard")
                        UserDefaults.standard.set(self.bPassword.txfInput.text!, forKey: "password")
                        let jwt = try decode(jwt: token)
                        let roleName:String = jwt.body["roleName"] as! String
                        let password: String = self.bPassword.txfInput.text ?? ""
                        if(roleName == "BAC_SI"){
                            // Bác sĩ login
                            self.gotoDoctormain()
                            return
                        }
                        else if(password == "123456"){
                            // bệnh nhận login lần đầu
                            Utilities.share.alertShowNotification("Thông báo", "Có vẻ đây là lần đăng nhập đầu tiên của bạn. Vui lòng đổi mật khẩu trước khi bắt đầu", "OK", self) { (_) in
                                let vc = ChangePassVC(nibName: String(describing: ChangePassVC.self), bundle: nil)
                                vc.oldPass = "123456"
                                self.navigationController?.pushViewController(vc, animated: true)
                                return
                            }
                        }
                        else{
                            self.gotoPatientMain()
                            return
                        }
                    } catch (let err) {
                        debugPrint(err)
                    }
                case .failure(let err):
                    debugPrint(err)
                }
            }
        }
    }

    func gotoDoctormain(){
        let listPatientVC = ListPatientVC(nibName: String(describing: ListPatientVC.self), bundle: nil)
        let listPatientNVC = UINavigationController.init(rootViewController: listPatientVC)

        let timeTableVC = TimeTableVC(nibName: String(describing: TimeTableVC.self), bundle: nil)
        let timeTableNVC = UINavigationController.init(rootViewController: timeTableVC)

        let theNewVC = TheNewVC(nibName: String(describing: TheNewVC.self), bundle: nil)
        let theNewNVC = UINavigationController.init(rootViewController: theNewVC)

        let settingVC = SettingVC(nibName: String(describing: SettingVC.self), bundle: nil)
        let settingNVC = UINavigationController.init(rootViewController: settingVC)

        let item0 = UITabBarItem()
        item0.title = "Danh sách"
        item0.image = UIImage(named: "History")
        item0.selectedImage = UIImage(named: "History_Pressed")
        listPatientVC.tabBarItem = item0

        let item1 = UITabBarItem()
        item1.title = "Lịch trình"
        item1.image = UIImage(named: "Account")
        item1.selectedImage = UIImage(named: "Account_Pressed")
        timeTableVC.tabBarItem = item1


        let item2 = UITabBarItem()
        item2.title = "Tin tức"
        item2.image = UIImage(named: "New")
        item2.selectedImage = UIImage(named: "New_Pressed")
        theNewVC.tabBarItem = item2

        let item3 = UITabBarItem()
        item3.title = "Cài đặt"
        item3.image = UIImage(named: "Setting")
        item3.selectedImage = UIImage(named: "Setting_Pressed")
        settingVC.tabBarItem = item3

        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = UIColor.red
        tabBarController.viewControllers = [listPatientNVC, timeTableNVC, theNewNVC, settingNVC]
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    func gotoPatientMain(){
        let vc = PatientMainVC(nibName: String(describing: PatientMainVC.self), bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
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
    extension LoginVC: TextFieldBaseViewDelegate{
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
