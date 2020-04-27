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

class ListPatientVC: BaseVC {
    
    @IBOutlet weak var tbvPatients: UITableView!
    var listUser: [UserModal] = []
    var listRoom: [RoomModal] = []
    var listUserInRoom: [[UserModal]] = []
    var keyboardSize: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        getDataFromServer()
    }
    override func initData() {
        tbvPatients.delegate = self
        tbvPatients.dataSource = self
        tbvPatients.register(PatientCell.self, forCellReuseIdentifier: "PatientCell")
        tbvPatients.register(UINib(nibName: "PatientCell", bundle: nil), forCellReuseIdentifier: "PatientCell")
//        tbvPatients.register(HeaderCell.self, forHeaderFooterViewReuseIdentifier: "HeaderCell")
//        tbvPatients.register(UINib(nibName: "HeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderCell")
        
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
                        self.listRoom = rooms
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
        let name = user.fullName ?? ""
        let dateOfBirth = user.dateOfBirth ?? ""
        let phoneNumber = user.phoneNumber ?? ""
        cell.shadowWidth = tbvPatients.bounds.width - 20
        cell.initUI()
        cell.fillData(name, dateOfBirth, phoneNumber)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = HeaderCell()
        let roomName = listRoom[section].name ?? ""
//        headerView.fillUI(roomName)
//        return headerView
        let viewheader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: viewheader.layer.bounds.width - 20, height: 50))
        label.text = roomName
        label.textColor = UIColor.black

        viewheader.addSubview(label)

        return viewheader
    
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
