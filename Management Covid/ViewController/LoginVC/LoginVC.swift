//
//  ConfirmCMNDVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/8/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import JWTDecode
import CoreLocation

class LoginVC: BaseVC,BaseButtonDelegate,BaseNavigationBarDelegate {
    @IBOutlet weak var scvScroll: UIScrollView!
    @IBOutlet weak var bNavigationBar: BaseNavigationBar!
    @IBOutlet weak var bCMND: TextFieldBaseView!
    @IBOutlet weak var bPassword: TextFieldBaseView!
    @IBOutlet weak var bButton: BaseButton!
    var keyboardSize: CGRect?
    var currentBase: TextFieldBaseView?
    var arrBV: [TextFieldBaseView] = []
    var idUser: String = ""
    var user = UserModal()
    
    var locationManager: CLLocationManager?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let identityCard = UserDefaults.standard.string(forKey: "identityCard") ?? ""
        let password = UserDefaults.standard.string(forKey: "password") ?? ""
        bCMND.txfInput.text = identityCard
        bPassword.txfInput.text = password
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingLocation()
        
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
        SocketIOManager.shared.connectSocket()
        SVProgressHUD.show(withStatus: statusSV)
        SVProgressHUD.setDefaultMaskType(.clear)
        let params: [String:Any] = ["identityCard":bCMND.txfInput.text!,
                                    "password": bPassword.txfInput.text!]
        RequestManager.share.sentRequestWithBody(URLs.urlLogin, .post, params) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404 || response.response?.statusCode == nil){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối mạng", "OK", self)
                return
            }
            if(response.response?.statusCode == 401){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại số CMND hoặc mật khẩu", "OK", self)
                return
            }
            if(response.response?.statusCode == 200) {
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
                        self.getProfile(token: token) { (num) in
                            if num == 1 {
                                self.goToMainVC(roleName, password)
                            } else {
                                Utilities.share.alertNotification("Thông báo", "Hiện tại đang không thể đăng nhập vào hệ thống. Vui lòng thử lại sau.", "OK", self)
                            }
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
    //MARK: - GetProfile
    func getProfile(token: String,_ complete: @escaping(Int)->Void){
        let headers :HTTPHeaders = ["Authorization":token]
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(.clear)
        RequestManager.share.sentRequestWithHeaders(URLs.urlGetProfile, headers) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet", "OK", self)
            }
            if(response.response?.statusCode == 200){
                switch response.result {
                case .success(_):
                    do {
                        let data = JSON(response.value!)
                        let user = try JSONDecoder().decode(UserModal.self, from: data["user"].rawData())
                        self.user = user
                        Utilities.share.setcurrUser(user)
                        complete(1)
                    } catch let err {
                        debugPrint(err)
                        complete(0)
                    }
                case .failure(let err):
                    debugPrint(err)
                    complete(0)
                }
            }
        }
    }
    
    func sentLocation(_ lat: CLLocationDegrees,_ long: CLLocationDegrees){
        let location: [String: Any] = ["x":"\(lat)","y":"\(long)"]
        let user = Utilities.share.getcurrUser()
        let idUser = user._id ?? ""
        let dataUpload: [String: Any] = ["id": idUser,"location":location]
        SocketIOManager.shared.emidServer("user-location", [dataUpload])
    }
    
    func goToMainVC(_ roleName: String, _ password: String){
        SocketIOManager.shared.connectSocket()
        if(roleName == "BAC_SI"){
            // Bác sĩ login
            self.gotoDoctormain()
            return
        }
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
        if(password == "123456"){
            // bệnh nhận login lần đầu
            Utilities.share.alertShowNotification("Thông báo", "Có vẻ đây là lần đăng nhập đầu tiên của bạn. Vui lòng đổi mật khẩu trước khi bắt đầu", "OK", self) { (_) in
                let vc = ChangePassVC(nibName: String(describing: ChangePassVC.self), bundle: nil)
                vc.oldPass = "123456"
                self.pushVC(vc)
                return
            }
        } else{
            if user.avatars?.count == 0 {
                let vc = CreateAvatarVC(nibName: String.init(describing: CreateAvatarVC.self), bundle: nil)
                vc.isDoctor = false
                pushVC(vc)
                return
            }
            self.gotoPatientMain()
            return
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
        self.navigationController?.pushViewController(vc, animated: true)
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


extension LoginVC {
    @objc func runTimedCode() {
        self.getLocation()
    }
    
    func settingLocation(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func getLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        if status == .denied || status == .restricted || CLLocationManager.locationServicesEnabled(){
            // show alert request usser enable location
            locationManager?.requestAlwaysAuthorization()
        }
        
        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined){
            locationManager?.requestWhenInUseAuthorization()
            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            locationManager?.requestAlwaysAuthorization()
            return
        }
        
        locationManager?.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            print("New location is \(locations)")
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            debugPrint("Lat: \(latitude!) || Long: \(longitude!)")
            sentLocation(location.coordinate.latitude, location.coordinate.longitude)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("===== Can not get location =====")
        Utilities.share.alertShowNotification("ERROR!", "Please allow we to get your location in your app's setting!", "OK", self) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension LoginVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch  status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user did not allow to get location data")
        case .restricted:
            print("parental control settinf disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't show before, usser haven't tab allow/disallow ")
        default:
            print("can not check")
        }
    }
}
