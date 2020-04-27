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
class TimeTableVC: BaseVC {
    @IBOutlet weak var bUser: BaseHeaderUser!
    @IBOutlet weak var lblLichTruc: UILabel!
    @IBOutlet weak var tbvLichTruc: UITableView!
    @IBOutlet weak var vColor: UIView!
    var idUser = ""
    var listShift:[shiftModal] = []
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        vColor.backgroundColor = .white
        getProfile()
        
    }
    
    override func initData() {
        tbvLichTruc.dataSource = self
        tbvLichTruc.delegate = self
        tbvLichTruc.register(LichTrucCell.self, forCellReuseIdentifier: "LichTrucCell")
        tbvLichTruc.register(UINib(nibName: "LichTrucCell", bundle: nil), forCellReuseIdentifier: "LichTrucCell")
    }
    
    func getProfile(){
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(.clear)
        RequestManager.share.sentRequestWithHeaders(URLs.urlGetProfile, headers) { (response) in
            SVProgressHUD.dismiss()
            self.vColor.backgroundColor = .clear
            if(response.response?.statusCode == 404){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet", "OK", self)
            }
            if(response.response?.statusCode == 200){
                switch response.result {
                case .success(_):
                    do {
                        let data = JSON(response.value!)
                        let user = try JSONDecoder().decode(UserModal.self, from: data["user"].rawData())
                        self.idUser = user._id ?? ""
                        self.setProfile(user)
                        self.getLichTruc()
                    } catch let err {
                        debugPrint(err)
                    }
                case .failure(let err):
                    debugPrint(err)
                }
            }
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
        let strURLAvatar = "\(URLs.host)/\(user.avatars![0])"
        let url = URL(string: strURLAvatar)
        bUser.imvAva.sd_setImage(with: url)
    }
    
}
extension TimeTableVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LichTrucCell", for: indexPath) as! LichTrucCell
        cell.fillData("Ngày 10/10/2020", "Thời gian trực: 7h00 - 12h00")
        return cell
    }
}
extension TimeTableVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
