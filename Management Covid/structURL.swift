//
//  structURL.swift
//  Management Covid
//
//  Created by Mai Tài on 4/16/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import Foundation
struct URLs {
    static let host = "http://207.148.71.252:7050"
//    static let host = "http://192.168.1.47:6666"
    //Dùng chung
    static let urlWebNew = "https://ncov.moh.gov.vn"
    static let urlLogin = host + "/api/user/login"
    static let urlGetProfile = host + "/api/user/"
    static let urlUploadAvatar = host + "/api/user/upload-avatars"
    static let urlChangePass = host + "/api/user/change-password"
    static let urlUserCheckin = host + "/api/user/diem-danh"
    static let urlSentCode = host + "/api/user/send-code"
    static let urlCheckCode = host + "/api/user/check-code"
    static let urlForgotPass = host + "/api/user/forgot-password"
    //Doctor
    static let ulrCreateDoctor = host + "/api/doctor/register"
    static let urlGetPatients = host + "/api/doctor/all-patient"
    static let urlGetAllListRoom = host + "/api/room/"
    static let urlCreatePatient = host + "/api/doctor/register-patient"
    static let urlAddPatientIntoRoom = host + "/api/doctor/add-patient-to-room/"// cộng thêm id của bệnh nhân vào sau cùng
    static let urlGetListShift = host + "/api/doctor/get-info-shift/"
    
    //checkin
    static let urlRoomCheckin = host + "/api/diemdanh/";
}
 
