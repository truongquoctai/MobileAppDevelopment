//
//  HeaderCell.swift
//  Management Covid
//
//  Created by Mai Tài on 4/26/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblRoomName:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultUI()
    }
    func defaultUI(){
        lblRoomName.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        lblRoomName.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        lblRoomName.text = ""
    }
    func fillUI(_ roomName : String){
        lblRoomName.text = roomName
    }

}
