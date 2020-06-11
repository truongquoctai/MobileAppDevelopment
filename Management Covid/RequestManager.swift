//
//  Request.swift
//  Management Covid
//
//  Created by Mai Tài on 4/12/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class RequestManager: NSObject {
    static let share = RequestManager()
    
    
    func sentRequestWithBody(_ strUrl: String,_ method: HTTPMethod,_ params:[String: Any], _ complete: @escaping(AFDataResponse<Any>)->Void){
        guard let url = URL(string: strUrl) else {
            return
        }
        AF.request(url, method: method, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            complete(response)
        }
        
    }
    func sentRequestWithParams(_ strUrl: String,_ method: HTTPMethod ,_ params:[String: Any], _ complete: @escaping(AFDataResponse<Any>)->Void){
        guard let url = URL(string: strUrl) else {
            return
        }
        AF.request(url, method: method, parameters: params, headers: nil).responseJSON { (response) in
            
            complete(response)
        }
        
        
    }
    func sentRequestWithHeaders(_ strUrl: String,_ headers: HTTPHeaders, _ complete: @escaping(AFDataResponse<Any>)->Void){
        guard let url = URL(string: strUrl) else {
            return
        }
        AF.request(url, headers: headers).responseJSON { (response) in
            complete(response)
        }
    }
    func setRequestWithQueryAndHeader(_ strUrl: String,_ query:[String: Any],_ headers: HTTPHeaders, _ complete: @escaping(AFDataResponse<Any>)->Void){
        guard let url = URL(string: strUrl) else {
            return
        }
        AF.request(url, method: .get, parameters: query, headers: headers).responseJSON { (response) in
            complete(response)
        }
    }
    func sentRequestWithHeaderAndBody(_ strUrl: String,_ method: HTTPMethod,_ params:[String: Any],_ headers: HTTPHeaders, _ complete: @escaping(AFDataResponse<Any>)->Void){
        guard let url = URL(string: strUrl) else {
            return
        }
        AF.request(url, method: method, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            
            complete(response)
        }
    }
    
    
    
}
