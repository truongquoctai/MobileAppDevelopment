//
//  structURL.swift
//  Management Covid
//
//  Created by Mai Tài on 4/16/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import Foundation
struct URLs {
    
    static let host = "http://207.148.71.252:6666"
    //Dùng chung
    static let urlWebNew = "https://vnexpress.net"
    static let urlLogin = host + "/api/user/login"
    static let urlGetProfile = host + "/api/user/"
    static let urlUploadAvatar = host + "/api/user/upload-avatars"
    static let urlChangePass = host + "/api/user/change-password"
    //Doctor
    static let ulrCreateDoctor = host + "/api/doctor/register"
    static let urlGetPatients = host + "/api/doctor/all-patient"
    static let urlGetAllListRoom = host + "/api/room/"
    static let urlCreatePatient = host + "/api/doctor/register-patient"
    static let urlAddPatientIntoRoom = host + "/api/doctor/add-patient-to-room/"// cộng thêm id của bệnh nhân vào sau cùng
    static let urlGetListShift = host + "/api/doctor/get-info-shift/"
}
