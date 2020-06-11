//
//  ListPatientVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/14/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwipeCellKit

class ListPatientVC: BaseVC {
    
    @IBOutlet weak var tbvPatients: UITableView!
    var listRoom: [RoomModal] = []
    var keyboardSize: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }
    override func initData() {
        tbvPatients.delegate = self
        tbvPatients.dataSource = self
        tbvPatients.register(PatientCell.self, forCellReuseIdentifier: "PatientCell")
        tbvPatients.register(UINib(nibName: "PatientCell", bundle: nil), forCellReuseIdentifier: "PatientCell")
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
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
                        self.listRoom = rooms.filter{ $0.idUser?.count != 0 }
                    } catch let err {
                        debugPrint(err)
                        debugPrint("ABC")
                    }
                case .failure(let err):
                    debugPrint(err)
                }
            }
            self.tbvPatients.reloadData()
            debugPrint("We have \(self.listRoom.count) room")
        }
        
    }
    
    func callNumber(number: String){
        if let phoneCallURL:URL = URL(string: "tel:\(number)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    func Direction(_ latitude: String, _ longitude: String){
        guard let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)")  else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
extension ListPatientVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return listRoom.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRoom[section].idUser?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as! PatientCell
        let user = listRoom[indexPath.section].idUser?[indexPath.row] ?? UserModal()
        cell.delegate = self
        let name = user.fullName ?? ""
        let dateOfBirth = user.dateOfBirth ?? ""
        let phoneNumber = user.phoneNumber ?? ""
        var imgAvatar = ""
        if user.avatars?.count ?? 0 > 0 {
            imgAvatar = user.avatars?[0] ?? ""
        }
        cell.shadowWidth = tbvPatients.bounds.width - 20
        cell.initUI(clShadow: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        if let dateCreate = user.createAt {
            cell.fillData(name, dateOfBirth, phoneNumber, imgAvatar, dateCreate: dateCreate)
            return cell
        }
        cell.fillData(name, dateOfBirth, phoneNumber, imgAvatar )
        return cell
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let roomName = listRoom[section].name ?? ""
        let viewheader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: viewheader.layer.bounds.width - 20, height: 50))
        label.text = roomName
        label.textColor = UIColor.black
        viewheader.addSubview(label)
        return viewheader
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func addActionCall(_ cell:UITableViewCell){
        
    }
}

extension ListPatientVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

//MARK: - SwipeTableViewCellDelegate
extension ListPatientVC: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let callAction = SwipeAction(style: .destructive, title: "Call") { (action, indexPath) in
            let phoneNumber = self.listRoom[indexPath.section].idUser![indexPath.row].phoneNumber ?? ""
            self.callNumber(number: phoneNumber)
            debugPrint(phoneNumber)
        }
        let findAction = SwipeAction(style: .destructive, title: "Location") { (action, indexPath) in
            debugPrint("Location")
            let gps = self.listRoom[indexPath.section].idUser?[indexPath.row].gps ?? []
            if gps.count != 0 {
                let lat = gps.first?.x ?? ""
                let long = gps.first?.y ?? ""
                if lat != "" && long != "" {
                    self.Direction(lat, long)
                } else {
                    Utilities.share.alertNotification("Thông báo", "Không tìm thấy dữ liệu định vị của user", "OK", self)
                }
            } else {
                Utilities.share.alertNotification("Thông báo", "Không tìm thấy dữ liệu định vị của user", "OK", self)
            }
        }
        callAction.backgroundColor = UIColor(named: "ColorCall")
        findAction.backgroundColor = UIColor(named: "ColorLocation")
        callAction.image = UIImage(named: "Call")
        findAction.image = UIImage(named: "Location")
        return [callAction,findAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        return options
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 {
            getDataFromServer()
        }
    }
}
