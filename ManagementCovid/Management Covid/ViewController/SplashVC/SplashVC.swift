//
//  SplashVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/5/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit

class SplashVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(TimeOut(sender:)), userInfo: nil, repeats: false)
    }

    @objc func TimeOut(sender: Timer){
        let vc = ChoiseVC.init(nibName: String(describing: ChoiseVC.self), bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }

}
