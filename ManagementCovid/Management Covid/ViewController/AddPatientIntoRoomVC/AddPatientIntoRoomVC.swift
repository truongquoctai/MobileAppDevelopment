//
//  AddPatientIntoRoomVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/17/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddPatientIntoRoomVC: BaseVC {
    @IBOutlet weak var bConfirm: BaseButton!
    @IBOutlet weak var clvRoom: UICollectionView!
    @IBOutlet weak var lblDesCription: UILabel!
    var patientName = ""
    var patientId = ""
    var idRoomSelected = ""
    var rowselected = -1
    var listRoom: [RoomModal] = []
    override func viewWillAppear(_ animated: Bool) {
        getDataFromServer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func initUI() {
        bConfirm.setTitle("Xác nhận", UIFont(name: Font.text, size: 18)!, .white)
        bConfirm.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))
        bConfirm.vContainer.layer.cornerRadius = 8
        lblDesCription.text = "Tên người cách ly: \(patientName)"
    }
    override func initData() {
        bConfirm.delegate = self
        clvRoom.delegate = self
        clvRoom.dataSource = self
        clvRoom.register(RoomCell.self, forCellWithReuseIdentifier: "RoomCell")
        clvRoom.register(UINib(nibName: String(describing: RoomCell.self), bundle: nil), forCellWithReuseIdentifier: "RoomCell")
        
    }
    
    func getDataFromServer(){
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        let query: [String: Any] = ["amount": 1000]
        SVProgressHUD.show(withStatus: "Loading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        RequestManager.share.setRequestWithQueryAndHeader(URLs.urlGetAllListRoom, query, headers) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet", "OK", self)
                return
            }
            if(response.response?.statusCode == 200){
                switch response.result {
                case .success(_):
                    do {
                        let data = JSON(response.value!)
                        let rooms = try JSONDecoder().decode([RoomModal].self, from: data["room"].rawData())
                        debugPrint(rooms)
                        self.listRoom = rooms
                    } catch let err {
                        debugPrint(err)
                        debugPrint("ABC")
                    }
                case .failure(let err):
                    debugPrint(err)
                }
            }
            self.clvRoom.reloadData()
            debugPrint("We have \(self.listRoom.count) room")
        }
        
    }
    
}
extension AddPatientIntoRoomVC: UICollectionViewDelegate{
    
}
extension AddPatientIntoRoomVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listRoom.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomCell", for: indexPath) as! RoomCell
        cell.defaultUI()
        let roomName = listRoom[indexPath.row].name ?? ""
        let maxMember = listRoom[indexPath.row].maxNumber ?? 0
        let empty = maxMember - (listRoom[indexPath.row].idUser?.count ?? 0)
        cell.fillUI(roomName, maxMember, empty)
        cell.fillCellHightLight(1, .black, .white)
        if(indexPath.row == rowselected){
            cell.fillCellHightLight(2, .red, .lightGray)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rowselected = indexPath.row
        idRoomSelected = listRoom[indexPath.row]._id ?? ""
        clvRoom.reloadData()
    }
    
}
extension AddPatientIntoRoomVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthHeight = (clvRoom.bounds.width-15)/3
        return CGSize(width: widthHeight, height: widthHeight)
    }
}
extension AddPatientIntoRoomVC: BaseButtonDelegate{
    func touchButton(view: UIView, button: UIButton) {
        let url = "\(URLs.urlAddPatientIntoRoom)\(patientId)"
        let params : [String: Any] = ["idRoom": idRoomSelected]
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        SVProgressHUD.show(withStatus: "Loading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        RequestManager.share.sentRequestWithHeaderAndBody(url, .post, params, headers) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet của bạn.", "OK", self)
                return
            }
//            if(response.response?.statusCode == 500){
//                Utilities.share.alertNotification("Thông báo", "Tài khoản đã tồn tại.", "OK", self)
//                return
//            }
            if(response.response?.statusCode == 200){
                switch response.result{
                case .success(_):
                    Utilities.share.alertShowNotification("Thông báo", "Thêm thành công", "OK", self) { (_) in
                        guard let vc1 = self.navigationController?.viewControllers[0] else{
                            return
                        }
                        self.navigationController?.popToViewController(vc1, animated: true)
                    }
                    break
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
