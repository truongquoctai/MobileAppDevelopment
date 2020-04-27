//
//  PatientMainVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/22/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class PatientMainVC: BaseVC {
    @IBOutlet weak var btnNews: UIButton!
    @IBOutlet weak var btnCheckin: UIButton!
    @IBOutlet weak var imgCheckin: UIImageView!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var vContainer: UIView!
    var nvcNews: UINavigationController!
    var nvcCheckin: UINavigationController!
    var nvcSetting: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func initUI() {
        self.nvcNews = UINavigationController.init(rootViewController:TheNewVC(nibName: String(describing: TheNewVC.self), bundle: nil))
        self.nvcCheckin = UINavigationController.init(rootViewController:CheckinVC(nibName: String(describing: CheckinVC.self), bundle: nil))
        self.nvcSetting = UINavigationController.init(rootViewController:SettingPatientVC(nibName: String(describing: SettingPatientVC.self), bundle: nil))
        imgCheckin.layer.cornerRadius = 8
        imgCheckin.loadGif(asset: "CheckinGif")
        imgCheckin.contentMode = .scaleToFill
    }
    override func initData() {
        addSubView(nvcNews, nvcCheckin, nvcSetting)
        changeBackgroundButton("New_Pressed", "Setting", "CheckinGif")
    }
    
    @IBAction func onbtnNews(_ sender: Any) {
        addSubView(nvcNews, nvcCheckin, nvcSetting)
        changeBackgroundButton("New_Pressed", "Setting", "CheckinGif")
    }
    @IBAction func onBtnCheckin(_ sender: Any) {
        addSubView(nvcCheckin, nvcNews, nvcSetting)
        changeBackgroundButton("New", "Setting", "CheckinGif_Pressed")
    }
    @IBAction func onBtnSetting(_ sender: Any) {
        addSubView(nvcSetting, nvcCheckin, nvcNews)
        changeBackgroundButton("New", "Setting_Pressed", "CheckinGif")
    }
    
    func addSubView(_ nvcViewShow: UINavigationController,_ nvcViewHide1: UINavigationController,_ nvcViewHide2: UINavigationController){
        nvcViewShow.view.frame = self.vContainer.bounds
        for view in self.vContainer.subviews {
            if (view == nvcViewHide1.view || view == nvcViewHide2 ){
                view.removeFromSuperview()
                break
            }
        }
        self.vContainer.addSubview(nvcViewShow.view)
        nvcViewShow.view.bringSubviewToFront(self.vContainer)
    }
    func changeBackgroundButton(_ imgBtnNews:String,_ imgBtnSetting:String,_ imgGifCheckin: String){
        btnNews.setBackgroundImage(UIImage.init(named: imgBtnNews), for: .normal)
        btnSetting.setBackgroundImage(UIImage.init(named: imgBtnSetting), for: .normal)
        imgCheckin.loadGif(asset: imgGifCheckin)
        imgCheckin.contentMode = .scaleToFill
    }
}
