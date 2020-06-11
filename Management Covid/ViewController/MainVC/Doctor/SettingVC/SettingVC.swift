//
//  SettingVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/14/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit

class SettingVC: BaseVC {
    @IBOutlet weak var bCreateUser: BaseSettingButton!
    @IBOutlet weak var bNotification: BaseSettingButton!
    @IBOutlet weak var bLanguages: BaseSettingButton!
    @IBOutlet weak var bFeedback: BaseSettingButton!
    @IBOutlet weak var bPrivacy: BaseSettingButton!
    @IBOutlet weak var bLogout: BaseSettingButton!
    var delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func initUI() {
        initNaviBar()
        bCreateUser.initUI("Thêm người cách ly", "Createpatient")
        bPrivacy.initUI("Đổi mật khẩu", "ico_privacy")
        bNotification.initUI("Thông Báo", "ico_noti")
        bLanguages.initUI("Đổi ngôn ngữ", "Languages")
        bFeedback.initUI("Phản hồi", "ico_feedback")
        bLogout.initUI("Đăng xuất", "ico_logout")
    }
    override func initData() {
        bCreateUser.dele = self
        bPrivacy.dele = self
        bNotification.dele = self
        bLanguages.dele = self
        bFeedback.dele = self
        bLogout.dele = self
    }
    private func initNaviBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        titleNavibar(text: "Cài đặt")
        
        //init left button
        
    }
    func titleNavibar(text: String) {
        navigationItem.title = text
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .font : DefaultSetting.boldSystemFont18
        ]
        navigationController?.navigationBar.titleTextAttributes =  strokeTextAttributes
    }
}
extension SettingVC: BaseSettingButtonDelegate{
    func clickBtn(_ view: UIView, _ sender: UIButton) {
        switch view {
        case bCreateUser:
            let vc = PatientSignUp.init(nibName: String(describing: PatientSignUp.self), bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
            return
        case bPrivacy:
            let vc = ChangePassVC.init(nibName: String(describing: ChangePassVC.self), bundle: nil)
            vc.oldPass = ""
            navigationController?.pushViewController(vc, animated: true)
            return
        case bLogout:
            let vc1 = delegate.navigation.viewControllers[1]
            delegate.navigation.popToViewController(vc1, animated: true)
        default:
            return
        }
    }
    
    
}
