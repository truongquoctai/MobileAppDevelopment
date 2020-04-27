//
//  Name : BaseButtonBack
//  Author : CuongBui
//
//  Created by Quang Công on 10/31/19.
//  Copyright © 2019 crosstech. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol BaseNavigationBarDelegate {
    func clickButtonBack(_ view:UIView, _ button: UIButton)
    func clickButtonIcon(_ view: UIView, _ button: UIButton)
}

@IBDesignable
class BaseNavigationBar: UIView {

    // MARK: - Variable
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnIcon: UIButton!
    var dele: BaseNavigationBarDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.defaultInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.defaultInit()
    }
    
    func defaultInit() {
        let bundle = Bundle(for: BaseNavigationBar.self)
        bundle.loadNibNamed("BaseNavigationBar", owner: self, options: nil)
        self.vContainer.fixInView(self)

        self.lblTitle.font = UIFont.init(name: Font.text, size: DefaultSetting.size18)
        self.lblTitle.font = DefaultSetting.boldSystemFont18
        self.lblTitle.textColor = Color.white
    }
    func setNavigate(_ iconBackName: String, _ title : String,  _ iconName : String){
        
        self.btnBack.setImage(UIImage(named: iconBackName), for: .normal)
        self.lblTitle.text = title
        //self.btnIcon.setTitle("", for: .normal)
        self.btnIcon.setImage(UIImage(named: iconName), for: .normal)
    }
    
    // MARK: - Action
    @IBAction func onBtnBack(_ sender: Any) {
        self.dele?.clickButtonBack(self, btnBack)
    }
    
    /*
    - Name : Action for btnIcon
    - Author: Dang Nhat Duy
    - Description: Thêm hàm action cho btnIcon
    */
    @IBAction func onBtnIcon(_ sender: UIButton) {
        self.dele?.clickButtonIcon(self, sender)
    }
}
