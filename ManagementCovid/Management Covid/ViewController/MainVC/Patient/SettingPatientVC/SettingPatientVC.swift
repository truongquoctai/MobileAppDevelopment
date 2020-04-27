//
//  SettingPatientVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/22/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit

class SettingPatientVC: BaseVC {
    @IBOutlet weak var bNotification: BaseSettingButton!
    @IBOutlet weak var bLanguages: BaseSettingButton!
    @IBOutlet weak var bFeedback: BaseSettingButton!
    @IBOutlet weak var bPrivacy: BaseSettingButton!
    @IBOutlet weak var bLogout: BaseSettingButton!
    var delegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func initUI() {
        initNaviBar()
        bPrivacy.initUI("Đổi mật khẩu", "ico_privacy")
        bNotification.initUI("Thông Báo", "ico_noti")
        bLanguages.initUI("Đổi ngôn ngữ", "Languages")
        bFeedback.initUI("Phản hồi", "ico_feedback")
        bLogout.initUI("Đăng xuất", "ico_logout")
    }
    override func initData() {
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
extension SettingPatientVC: BaseSettingButtonDelegate{
    func clickBtn(_ view: UIView, _ sender: UIButton) {
        switch view {
        case bLogout:
            let vc1 = delegate.navigation.viewControllers[1]
            delegate.navigation.popToViewController(vc1, animated: true)
            return
        case bPrivacy:
            let vc = ChangePassVC(nibName: String(describing: ChangePassVC.self), bundle: nil)
            vc.oldPass = ""
            navigationController?.pushViewController(vc, animated: true)
            return
        default:
            break
        }
    }
    
    
    
    
}
