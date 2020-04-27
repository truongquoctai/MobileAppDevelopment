//
//  CheckinVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/22/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit

class CheckinVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func initUI() {
        initNaviBar()
    }
    override func initData() {
        
    }
    
    
    
    private func initNaviBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        titleNavibar(text: "Điểm danh")
        
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
