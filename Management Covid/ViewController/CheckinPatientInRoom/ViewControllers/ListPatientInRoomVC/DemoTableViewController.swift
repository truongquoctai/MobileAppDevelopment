//
//  DemoTableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 24/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import Alamofire
import expanding_collection
import SwipeCellKit
import SwiftyJSON

class DemoTableViewController: ExpandingTableViewController {
    fileprivate var scrollOffsetY: CGFloat = 0
    var usersChecked: [String] = []
    var currRoom = RoomModal() {
        didSet{
            tableView.reloadData()
            let roomName = currRoom.name ?? ""
            titleNavibar(text: "Điểm danh phòng \(roomName)")
            fillUsersChecked()
        }
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        initNaviBar()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(PatientCell.self, forCellReuseIdentifier: "PatientCell")
        tableView.register(UINib(nibName: "PatientCell", bundle: nil), forCellReuseIdentifier: "PatientCell")
        tableView.register(CustomeCell.self, forCellReuseIdentifier: "CustomeCell")
        tableView.register(UINib(nibName: "CustomeCell", bundle: nil), forCellReuseIdentifier: "CustomeCell")
        SocketIOManager.shared.socketCheckIn { (datas) in
            let dataJson = JSON(datas[0])
            let userId = dataJson["id"].string ?? ""
            if userId != "" {
                self.usersChecked.append(userId)
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func fillUsersChecked() {
//        usersChecked = Array(repeating: "", count: currRoom.idUser!.count)
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

// MARK: Helpers

extension DemoTableViewController {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func initNaviBar() {
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true);
        navigationController?.navigationBar.barTintColor = UIColor.red
        titleNavibar(text: "Điểm danh")
        // init Right button
        let btnDone = UIButton(type: .custom)
        btnDone.setTitle("Done", for: .normal)
        btnDone.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        let selectItem = UIBarButtonItem(customView: btnDone)
        self.navigationItem.setRightBarButton(selectItem, animated: true)
    }
    
    func titleNavibar(text: String) {
        navigationItem.title = text
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .font : DefaultSetting.boldSystemFont18
        ]
        navigationController?.navigationBar.titleTextAttributes =  strokeTextAttributes
    }

    @objc func didTapDone() {
        let roomName = self.currRoom.name ?? ""
        Utilities.share.alertConfirm("Thông báo", "Bạn có chắc muốn kết thúc phiên điểm danh cho phòng \(roomName)", "Cancel", "OK", self) { (flag) in
            if flag == 1 {
                self.endCheckin(idRoom: self.currRoom._id!) { (num) in
                    if num == 1 {
                        self.popTransitionAnimation()
                    }
                }
            }
        }
    }
    
    func endCheckin(idRoom: String,_ complete: @escaping(Int)->Void){
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        let body:[String: Any] = ["idRoom": idRoom]
        SVProgressHUD.show(withStatus: "Loading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        RequestManager.share.sentRequestWithHeaderAndBody(URLs.urlRoomCheckin, .put, body, headers) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404 || response.response?.statusCode == nil){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet", "OK", self)
                complete(0)
                return
            }
            if response.response?.statusCode == 400 {
                Utilities.share.alertNotification("Thông báo", "Phòng đã kết thúc điểm danh", "OK", self)
                complete(1)
                return
            }
            if(response.response?.statusCode == 200){
                complete(1)
            }
        }
    }
    
    
}

// MARK: UIScrollViewDelegate

extension DemoTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -25 {
            let roomName = self.currRoom.name ?? ""
            Utilities.share.alertConfirm("Thông báo", "Bạn có chắc muốn kết thúc phiên điểm danh cho phòng \(roomName)", "Cancel", "OK", self) { (flag) in
                if flag == 1 {
                    self.endCheckin(idRoom: self.currRoom._id!) { (num) in
                        if num == 1 {
                            self.popTransitionAnimation()
                        }
                    }
                }
            }
        }
        scrollOffsetY = scrollView.contentOffset.y
    }
}

extension DemoTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currRoom.idUser?.count ?? 0) + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeCell", for: indexPath) as! CustomeCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as! PatientCell
        let user = currRoom.idUser![indexPath.row - 1]
        cell.delegate = self
        let name = user.fullName ?? ""
        let dateOfBirth = user.dateOfBirth ?? ""
        let phoneNumber = user.phoneNumber ?? ""
        var imgAvatar = ""
        if user.avatars?.count ?? 0 > 0 {
            imgAvatar = user.avatars?[0] ?? ""
        }
        cell.shadowWidth = tableView.bounds.width - 20
        cell.initUI(clShadow: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        cell.setDidChecked()
        for id in usersChecked {
            if user._id == id {
                cell.setChecked()
            }
        }
        if let dateCreate = user.createAt {
            cell.fillData(name, dateOfBirth, phoneNumber, imgAvatar, dateCreate: dateCreate)
            return cell
        }
        cell.fillData(name, dateOfBirth, phoneNumber, imgAvatar )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 124
        }
        return 100
    }
}

extension DemoTableViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let callAction = SwipeAction(style: .destructive, title: "Call") { (action, indexPath) in
            let phoneNumber = self.currRoom.idUser![indexPath.row - 1].phoneNumber ?? ""
            self.callNumber(number: phoneNumber)
            debugPrint(phoneNumber)
        }
        let findAction = SwipeAction(style: .destructive, title: "Location") { (action, indexPath) in
            debugPrint("Location")
//            self.Direction("10.782462", "106.694376")
            
            let gps = self.currRoom.idUser?[indexPath.row].gps ?? []
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
}
