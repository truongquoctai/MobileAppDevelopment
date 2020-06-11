//
//  BaseAvatar.swift
//  Management Covid
//
//  Created by Mai Tài on 4/8/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
protocol BaseAvatarDelegate {
    func touchOnBtn(_ view: UIView, _ sender: UIButton)
}

@IBDesignable
class BaseAvatar: UIView {
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var vView: UIView!
    @IBOutlet weak var vCorner: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnAvatar: UIButton!
    var delegate: BaseAvatarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        defaultInit()
    }
    func defaultInit(){
        let bundle = Bundle(for: BaseAvatar.self)
        bundle.loadNibNamed("BaseAvatar", owner: self, options: nil)
        vContainer.fixInView(self)
        vCorner.setCornerRadius(vCorner.bounds.height / 2)
        lblTitle.font = UIFont(name: Font.text, size: 18)
        vView.borderColor = .lightGray
        vView.borderWidth = 0.2
    }
    func fillUI(_ title: String){
        lblTitle.text = title
        
    }
    
    
    @IBAction func onBtnAvatar(_ sender: Any) {
        delegate?.touchOnBtn(self, btnAvatar)
    }
    
}
