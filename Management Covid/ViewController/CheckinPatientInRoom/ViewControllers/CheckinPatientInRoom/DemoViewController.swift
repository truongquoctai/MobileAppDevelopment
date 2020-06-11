//
//  DemoViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import expanding_collection
import SwiftyJSON
import Alamofire

class DemoViewController: ExpandingViewController {

    typealias ItemInfo = (imageName: String, title: String)
    fileprivate var cellsIsOpen = [Bool]()

    @IBOutlet var pageLabel: UILabel!
    var imgFront = 1
    var listRoom: [RoomModal] = []
    
}

// MARK: - Lifecycle 🌎

extension DemoViewController {

    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 460)
        super.viewDidLoad()
        getDataFromServer()
        registerCell()
        addGesture(to: collectionView!)
        fillCellIsOpenArray()
        initNaviBar()
        pageLabel.text = "1/\(listRoom.count)"
    }
    
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
        navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK: Helpers

extension DemoViewController {

    fileprivate func registerCell() {

        let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
    }

    fileprivate func fillCellIsOpenArray() {
        cellsIsOpen = Array(repeating: false, count: listRoom.count)
    }

    fileprivate func getViewController() -> DemoTableViewController {
        let toViewController: DemoTableViewController = Utilities.share.createVC(SBName: "Main", "DemoTableViewController") as! DemoTableViewController
        return toViewController
    }

}

/// MARK: Gesture
extension DemoViewController {
    func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
        block(value)
        return value
    }
    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        

        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }

    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? DemoCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            let vc = getViewController()
            vc.currRoom = listRoom[indexPath.row]
            startCheckin(idRoom: listRoom[indexPath.row]._id ?? "") { (flag) in
                if flag == 1 {
                    self.pushToViewController(vc)
                } else {
                    Utilities.share.alertNotification("Thông báo", "Phòng đang được điểm danh ", "OK", self)
                }
            }

        }

        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
}

// MARK: UIScrollViewDelegate

extension DemoViewController {

    func scrollViewDidScroll(_: UIScrollView) {
        pageLabel.text = "\(currentIndex + 1)/\(listRoom.count)"
    }
}

// MARK: UICollectionViewDataSource

extension DemoViewController {

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? DemoCollectionViewCell else { return }
        let index = indexPath.row % listRoom.count
        let name = "img\(imgFront)"
        imgFront += 1
        if imgFront == 4 {
            imgFront = 1
        }
        cell.backgroundImageView?.image = UIImage(named: name)
        cell.customTitle.text = listRoom[indexPath.row].name
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
            , currentIndex == indexPath.row else { return }

        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            let vc = getViewController()
            vc.currRoom = listRoom[indexPath.row]
            startCheckin(idRoom: listRoom[indexPath.row]._id ?? "") { (flag) in
                if flag == 1 {
                    self.pushToViewController(vc)
                } else {
                    Utilities.share.alertNotification("Thông báo", "Phòng đang được điểm danh ", "OK", self)
                }
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension DemoViewController {

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return listRoom.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath)
    }
}

extension DemoViewController {
    func getDataFromServer(){
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        let query: [String: Any] = ["amount": 1000]
        SVProgressHUD.show(withStatus: "Loading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        RequestManager.share.setRequestWithQueryAndHeader(URLs.urlGetAllListRoom, query, headers) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404 || response.response?.statusCode == nil){
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
                        self.fillCellIsOpenArray()
                    } catch let err {
                        debugPrint(err)
                        debugPrint("ABC")
                    }
                case .failure(let err):
                    debugPrint(err)
                }
            }
            self.collectionView?.reloadData()
            debugPrint("We have \(self.listRoom.count) room")
        }
    }
    
    func startCheckin(idRoom: String,_ complete: @escaping(Int)->Void){
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        let body:[String: Any] = ["idRoom": idRoom]
        SVProgressHUD.show(withStatus: "Loading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        RequestManager.share.sentRequestWithHeaderAndBody(URLs.urlRoomCheckin, .post, body, headers) { (response) in
            SVProgressHUD.dismiss()
            if(response.response?.statusCode == 404 || response.response?.statusCode == nil){
                Utilities.share.alertNotification("Thông báo", "Vui lòng kiểm tra lại kết nối internet", "OK", self)
                complete(0)
                return
            }
            if response.response?.statusCode == 400 {
                let data = JSON(response.value!)
                let message = data["message"]
                Utilities.share.alertNotification("Thông báo", "\(message)", "OK", self)
                complete(0)
                return
            }
            if(response.response?.statusCode == 200){
                complete(1)
                return
            }
            let data = JSON(response.value!)
            let message = data["message"]
            Utilities.share.alertNotification("Thông báo", "\(message)", "OK", self)
            complete(0)
            return
        }
    }
}
