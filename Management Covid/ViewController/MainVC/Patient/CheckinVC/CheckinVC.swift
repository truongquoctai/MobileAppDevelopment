//
//  CheckinVC.swift
//  Management Covid
//
//  Created by Mai Tài on 4/22/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class CheckinVC: BaseVC,AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var vCheckin: UIView!
    @IBOutlet weak var imgCheckin: UIImageView!
    @IBOutlet weak var bBtnCheckin: BaseButton!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI()
    }
    func fillUI(){
        bBtnCheckin.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))
        bBtnCheckin.setCornerRadius(5)
        bBtnCheckin.layer.borderWidth = 1.5
        bBtnCheckin.layer.borderColor = UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1).cgColor
        bBtnCheckin.setTitle("Điểm danh",UIFont(name: "Montserrat", size: 18)!, .white)
        bBtnCheckin.setBGColor(UIColor(red: 0.48, green: 0.77, blue: 0.41, alpha: 1))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpCapture()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.captureSession.stopRunning()
    }
    override func initUI() {
        initNaviBar()
    }
    override func initData() {
        bBtnCheckin.delegate = self
    }
    
    func setUpCapture() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        guard let frontCamera = AVCaptureDevice.devices().filter({ $0.position == .front })
            .first else {
           fatalError("Front camera not found")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            //Step 9
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    private func initNaviBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        titleNavibar(text: "Điểm danh")
    }
    
    func titleNavibar(text: String) {
        navigationItem.title = text
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.white,
            .font : DefaultSetting.boldSystemFont18
        ]
        navigationController?.navigationBar.titleTextAttributes =  strokeTextAttributes
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData) ?? UIImage()
        self.imgCheckin.image = image
        self.captureSession.stopRunning()
        checkIn(image)
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        vCheckin.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.vCheckin.bounds
            }
        }
    }
    func checkIn(_ image: UIImage){
        upload(image: image)
    }
    
    func upload(image: UIImage) {
        SVProgressHUD.show(withStatus: "Uploading ...")
        SVProgressHUD.setDefaultMaskType(.clear)
        guard let data0 = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers :HTTPHeaders = ["Authorization":token]
        let  multipartFormData = MultipartFormData()
        multipartFormData.append(data0, withName: "image", fileName: "img.jpg", mimeType: "image/png")
        
        AF.upload(multipartFormData: multipartFormData ,to: URLs.urlUserCheckin, usingThreshold: UInt64.init(), method: .post , headers: headers)
            .uploadProgress { progress in
                 print("Upload Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                debugPrint(response)
                SVProgressHUD.dismiss()
                if response.response?.statusCode == 404 || response.response?.statusCode == nil {
                    Utilities.share.alertNotification("Lỗi", "Điểm danh thất bại.", "OK", self)
                }
                if response.response?.statusCode == 200 {
                    switch response.result {
                    case .success(_):
                        Utilities.share.alertNotification("Chúc mừng bạn", "Điểm danh thành công.", "OK", self)
                    case .failure(let err):
                        Utilities.share.alertNotification("Lỗi", err.errorDescription ?? "Điểm danh thất bại.", "OK", self)
                    }
                    
                } else {
                    let data = JSON(response.value!)
                    let message = data["message"]
                    Utilities.share.alertNotification("Lỗi","\(message).", "OK", self)
                }
                self.setUpCapture()
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)

        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            // Take the user to Settings app to possibly change permission.
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 12.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Finished opening URL
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        })
        alert.addAction(settingsAction)

        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    
    
}
extension CheckinVC: BaseButtonDelegate{
    func touchButton(view: UIView, button: UIButton) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

        switch (authStatus){

        case .notDetermined:
            showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        case .restricted:
            showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        case .denied:
            showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        case .authorized:
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        @unknown default:
            print("Something wrong here!")
        }
    }
    
}
