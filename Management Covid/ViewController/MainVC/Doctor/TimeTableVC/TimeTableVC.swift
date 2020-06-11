//
//  TimeTableVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/14/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
class TimeTableVC: BaseVC, UINavigationControllerDelegate {
    @IBOutlet weak var bUser: BaseHeaderUser!
    @IBOutlet weak var lblLichTruc: UILabel!
    @IBOutlet weak var tbvLichTruc: UITableView!
    @IBOutlet weak var vColor: UIView!
    var idUser = ""
    var listShift:[shiftModal] = []
    var avatar = UIImage()
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        vColor.backgroundColor = .white
//        getProfile()
        self.vColor.isHidden = true
        let user = Utilities.share.getcurrUser()
        self.idUser = user._id ?? ""
        self.setProfile(user)
        self.getLichTruc()
    }
    
    override func initData() {
        tbvLichTruc.dataSource = self
        tbvLichTruc.delegate = self
        tbvLichTruc.register(LichTrucCell.self, forCellReuseIdentifier: "LichTrucCell")
        tbvLichTruc.register(UINib(nibName: "LichTrucCell", bundle: nil), forCellReuseIdentifier: "LichTrucCell")
        bUser.callbackChangeAvata = {[weak self] in
            self?.changeAvata()
        }
    }
    
    func getLichTruc(){
        let url = "\(URLs.urlGetListShift)\(idUser)"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(.clear)
        RequestManager.share.sentRequestWithHeaders(url, headers) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet", "OK", self)
            }
            if(response.response?.statusCode == 200){
                switch response.result {
                case .success(_):
                    do {
                        let data = JSON(response.value!)
                        let listShift = try JSONDecoder().decode([shiftModal].self, from: data["shift"].rawData())
                        self.listShift = listShift
                        if(listShift.count != 0){
                            let month = Utilities.share.getDateTimeFromTimeStapm(Double(listShift[0].startTime!), "MM/yyyy")
                            self.lblLichTruc.text = "Lịch trực tháng \(month)"
                        }
                        
                        self.tbvLichTruc.reloadData()
                    } catch let err {
                        debugPrint(err)
                    }
                case .failure(let err):
                    debugPrint(err)
                }
            }
        }
    }
    
    func setProfile(_ user: UserModal){
        bUser.txfBio.text = user.fullName
        bUser.txfEmail.text = user.email
        bUser.txfPhone.text = user.phoneNumber
        bUser.txfDoB.text = user.dateOfBirth
        if user.avatars?.count != 0 {
            let strURLAvatar = "\(URLs.host)/\(user.avatars![0])"
                   let url = URL(string: strURLAvatar)
                   bUser.imvAva.sd_setImage(with: url)
        }
       
    }
    func changeAvata(){
        openCamera()
    }
    func openCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraDevice = .front
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func fillImage(_ image: UIImage) {
        bUser.imvAva.image = image
        upload(image: image)
    }
    
    func upload(image: UIImage) {
        SVProgressHUD.show(withStatus: "Uploading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        guard let data0 = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        let  multipartFormData = MultipartFormData()
        multipartFormData.append(data0, withName: "avatars", fileName: "\(idUser)_img0.jpg", mimeType: "image/png")
        
        AF.upload(multipartFormData: multipartFormData ,to: URLs.urlUploadAvatar, usingThreshold: UInt64.init(), method: .post , headers: headers)
            .uploadProgress { progress in
                 print("Upload Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result{
                case .success(_):
                     let data = JSON(response.value!)
                    debugPrint(data)
                case .failure(let err):
                    Utilities.share.alertNotification("Thông báo", "Lưu ảnh thất bại. Vui lòng thử lại vào lần sau.", "OK", self)
                    debugPrint(err)
                    
                }
                SVProgressHUD.dismiss()
        }
    }
}
extension TimeTableVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listShift.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LichTrucCell", for: indexPath) as! LichTrucCell
        let date = Utilities.share.getDateTimeFromTimeStapm(Double(listShift[indexPath.row].startTime!), "dd/MM/yyyy")
        let startTime = Utilities.share.getDateTimeFromTimeStapm(Double(listShift[indexPath.row].startTime!), "HH:mm")
        let endTime = Utilities.share.getDateTimeFromTimeStapm(Double(listShift[indexPath.row].endTime!), "HH:mm")
        cell.fillData("Ngày \(date)", "Thời gian trực: \(startTime) - \(endTime)")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTimeStamp = Date().currentTimeMillis()
//        if myTimeStamp >= (listShift[indexPath.row].startTime!) && myTimeStamp <= (listShift[indexPath.row].endTime!) {
            debugPrint("You can checkin")
            let vc = Utilities.share.createVC(SBName: "Main", "DemoViewController")
            navigationController?.pushViewController(vc, animated: true)
//        } else {
//            debugPrint("You can't checkin")
//            Utilities.share.alertNotification("Thông báo", "Hiện tại đang không phải là ca trực của bạn", "OK", self)
//        }
    }
}

extension TimeTableVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
//MARK: - UIImagePickerControllerDelegate
extension TimeTableVC: UIImagePickerControllerDelegate{
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
        print(" size: \(image.size)")
        avatar = image
        fillImage(avatar)
    }

}
