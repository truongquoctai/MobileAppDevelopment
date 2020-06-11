//
//  UserModal.swift
//  Management Covid
//
//  Created by Mai Tài on 4/11/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import Foundation
import UIKit
struct UserModal: Codable {
    var avatars: [String]?
    var gender: Int?
    var isActive: Bool?
    var createAt: Int?
    //gps
    var _id: String?
    var address: String?
    var passWord: String?
    var phoneNumber: String?
    var dateOfBirth: String?
    var identityCard: String?
    var fullName: String?
    var email: String?
    var idRole: RoleModal?
    var idCaTruc: String?
    var __v: Int?
    
    var gps: [LocationModal]?
    init(){
        _id = ""
        fullName = ""
        identityCard = ""
        dateOfBirth = "1/1/1970"
        gender = 3
        createAt = 0
        address = ""
        phoneNumber = ""
        email = ""
        passWord = ""
        avatars = []
        idRole = RoleModal()
        __v = 0
        gps = []
    }
}
struct LocationModal: Codable {
    var x: String?
    var y: String?
    init() {
        x = ""
        y = ""
    }
}

struct RoleModal: Codable {
    var _id: String?
    var __v: Int?
    var name: String?
    init() {
        _id = ""
        __v = 0
        name = ""
    }
}

struct RoomModal: Codable {
    var currentNumber: Int?
    var idUser: [UserModal]?
    var _id: String?
    var maxNumber: Int?
    var address: String?
    var name: String?
    var __v: Int?
    init() {
        currentNumber = 0
        idUser = []
        _id = ""
        maxNumber = 0
        address = ""
        name = ""
        __v = 0
    }
}

struct shiftModal:Codable{
    var _id: String?
    var startTime: Int?
    var endTime: Int?
    var __v: Int?
    var idUser: [UserModal]?
    init() {
        _id = ""
        startTime = 0
        endTime = 0
        __v = 0
        idUser = []
    }
}
