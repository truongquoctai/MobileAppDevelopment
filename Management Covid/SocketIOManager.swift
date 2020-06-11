//
//  SocketIOManager.swift
//  DistributedSystem
//
//  Created by Trương Quốc Tài on 9/27/19.
//  Copyright © 2019 Trương Quốc Tài. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON
import UserNotifications

class SocketIOManager:NSObject{
    static let shared = SocketIOManager()
    var socket: SocketIOClient!
    let manager = SocketManager(socketURL: URL(string: URLs.host)!, config: [.log(true), .compress])
    
    override init() {
        super.init()
        socket = manager.defaultSocket
        
        
    }
    func connectSocket() {
        socket.connect()
        socket!.on(clientEvent: .connect) {data, ack in
            print("===========================")
            print(data)
            print("===========================")
        }
    }
    
    func socketCheckIn(_ completed: @escaping([Any]) -> Void){
        if checkConnected(self.socket) {
            socket!.on("checkInDone"){data, ack in
                completed(data)
                print("+++++++++++++++")
            }
        } else {
            connectSocket()
            socketCheckIn(completed)
        }
        
    }
    
    
    func onSent(_ even:String){
        if checkConnected(self.socket){
            socket!.on(even) {data, ack in
                print(even)
                print(data)
            }
        }
        else{
            self.connectSocket()
        }
    }
    
    func emidServer(_ event: String,_ data:[Any]){
        if checkConnected(self.socket){
            self.socket.emit(event, with: data)
        }
        else{
            self.connectSocket()
        }
    }
    
    func checkConnected(_ socket: SocketIOClient) -> Bool{
        if(socket.status == SocketIOStatus.connected){
            return true
        }
        else{
            return false
        }
    }
    
    func onNotification(){
        if checkConnected(self.socket){
            socket!.on("start-check-in"){data, ack in
                print("========================")
                let content = UNMutableNotificationContent()
                content.title = "Thông báo"
                content.subtitle = "Điểm danh "
                content.body = "Đã tới giờ điểm danh của bạn."
                content.sound = UNNotificationSound.default
                // 3
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 8, repeats: false)
                let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
                // 4
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        else{
            self.connectSocket()
        }
        
    }
}
