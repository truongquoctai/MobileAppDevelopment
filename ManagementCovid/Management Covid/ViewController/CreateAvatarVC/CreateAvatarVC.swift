//
//  CreateAvatarVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/8/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class CreateAvatarVC: BaseVC,UINavigationControllerDelegate {
    @IBOutlet weak var bAvatar1: BaseAvatar!
    @IBOutlet weak var bAvatar2: BaseAvatar!
    @IBOutlet weak var bAvatar3: BaseAvatar!
    @IBOutlet weak var bAvatar4: BaseAvatar!
    @IBOutlet weak var bAvatar5: BaseAvatar!
    @IBOutlet weak var bAvatar6: BaseAvatar!
    @IBOutlet weak var bKeep: BaseButton!
    @IBOutlet weak var bRegister: BaseButton!
    var listAvatar:[UIImage] = [UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage()]
    var views:[BaseAvatar] = []
    var index = 0
    var user :UserModal?
    var params:[String: Any]?
    var isDoctor = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isDoctor){
            Utilities.share.alertNotification("Chúc mừng", "Tạo tài khoản thành công. Bạn cần đăng ký ảnh để có thể điểm danh.", "OK", self)
        }
    }
    override func initUI() {
        bAvatar1.fillUI("Chụp giữa")
        bAvatar2.fillUI("Chụp giữa góc rộng")
        bAvatar3.fillUI("Chụp lệch trái")
        bAvatar4.fillUI("Chụp lệch phải")
        bAvatar5.fillUI("Chụp lệch trên")
        bAvatar6.fillUI("Chụp lệch dưới")
        
        bKeep.setTitle("Để sau", UIFont(name: Font.text, size: 18)!, .white)
        bKeep.setBGColor(.blue)
        bKeep.setCornerRadius(20)
        
        bRegister.setTitle("Xác nhận", UIFont(name: Font.text, size: 18)!, .white)
        bRegister.setBGColor(.red)
        bRegister.setCornerRadius(20)
    }
    override func initData() {
        bAvatar1.delegate = self
        bAvatar2.delegate = self
        bAvatar3.delegate = self
        bAvatar4.delegate = self
        bAvatar5.delegate = self
        bAvatar6.delegate = self
        bKeep.delegate = self
        bRegister.delegate = self
        views = [bAvatar1,bAvatar2,bAvatar3,bAvatar4,bAvatar5,bAvatar6]
        
    }
    private func fillImage(_ views:[BaseAvatar]){
        views[0].imgAvatar.image = listAvatar[0]
        views[1].imgAvatar.image = listAvatar[1]
        views[2].imgAvatar.image = listAvatar[2]
        views[3].imgAvatar.image = listAvatar[3]
        views[4].imgAvatar.image = listAvatar[4]
        views[5].imgAvatar.image = listAvatar[5]
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
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func gotoMainVC(){
        if(isDoctor){
            gotoDoctormain()
        }
        else{
            gotoPatientMain()
        }
    }
}

extension CreateAvatarVC: BaseAvatarDelegate{
    func touchOnBtn(_ view: UIView, _ sender: UIButton) {
        switch  view {
        case bAvatar1:
            debugPrint("them anh 0")
            index = 0
            break
        case bAvatar2:
            debugPrint("them anh 1")
            index = 1
            break
        case bAvatar3:
            debugPrint("them anh 2")
            index = 2
            break
        case bAvatar4:
            debugPrint("them anh 3")
            index = 3
            break
        case bAvatar5:
            debugPrint("them anh 4")
            index = 4
            break
        case bAvatar6:
            debugPrint("them anh 5")
            index = 5
            break
        default:
            break
        }
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraDevice = .front
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension CreateAvatarVC: BaseButtonDelegate{
    func touchButton(view: UIView, button: UIButton) {
        if(view == bKeep){
            gotoDoctormain()
        }
        if(view == bRegister){
            for image in listAvatar{
                if(image.size.height == 0){
                    Utilities.share.alertNotification("Thông báo", "Bạn phải chụp đủ 6 tấm trước khi xác nhận", "OK", self)
                    return
                }
            }
            upload(images: listAvatar)
        }
    }
    
    func upload(images: [UIImage]) {
        SVProgressHUD.show(withStatus: "Uploading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        guard let data0 = images[0].jpegData(compressionQuality: 0.9),
            let data1 = images[1].jpegData(compressionQuality: 0.9),
            let data2 = images[2].jpegData(compressionQuality: 0.9),
            let data3 = images[3].jpegData(compressionQuality: 0.9),
            let data4 = images[4].jpegData(compressionQuality: 0.9),
            let data5 = images[5].jpegData(compressionQuality: 0.9) else {
            return
        }
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        let  multipartFormData = MultipartFormData()
        multipartFormData.append(data0, withName: "avatars", fileName: "img0.jpg", mimeType: "image/png")
        multipartFormData.append(data1, withName: "avatars", fileName: "img1.jpg", mimeType: "image/png")
        multipartFormData.append(data2, withName: "avatars", fileName: "img2.jpg", mimeType: "image/png")
        multipartFormData.append(data3, withName: "avatars", fileName: "img3.jpg", mimeType: "image/png")
        multipartFormData.append(data4, withName: "avatars", fileName: "img4.jpg", mimeType: "image/png")
        multipartFormData.append(data5, withName: "avatars", fileName: "img5.jpg", mimeType: "image/png")
        
        AF.upload(multipartFormData: multipartFormData ,to: URLs.urlUploadAvatar, usingThreshold: UInt64.init(), method: .post , headers: headers)
            .uploadProgress { progress in
                 print("Upload Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                debugPrint(response)
                self.gotoMainVC()
                SVProgressHUD.dismiss()
        }
    }
}

extension CreateAvatarVC: UIImagePickerControllerDelegate{
    /*
     Name : imagePickerController
     Author : TRUONG QUOC TAI
     Discription : Lấy ảnh vừa chụp từ camera gán vào imgAvatar ở màn hình Register
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        // print out the image size as a test
        print("index: \(index); size: \(image.size)")
        listAvatar[index] = image
        fillImage(views)
    }

}
