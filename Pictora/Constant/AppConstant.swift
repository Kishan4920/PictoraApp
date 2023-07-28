//
//  AppConstant.swift
//  Pictora
//
//  Created by Raaj Patel on 27/07/23.
//

import Foundation
import UIKit
import SystemConfiguration


let iPad = UIDevice.current.userInterfaceIdiom == .pad ? true : false // to check if device is iPad

enum UserDefaultsKeys : String{
    case authenticationToken
}

extension UserDefaults{
    func setAuthenticationToken(value : String){
        setValue(value, forKey: UserDefaultsKeys.authenticationToken.rawValue)
        synchronize()
    }
    
    func getAuthenticationToken() -> String{
        return (value(forKey: UserDefaultsKeys.authenticationToken.rawValue) as? String) ?? ""
    }
}


class AppConstant : NSObject{
    
    class func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
    
    class func loadImage(from url: URL){
        //downloading images through urlsession
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            guard let data = data, let imagedata = UIImage(data: data) else {
                print("Invalid image data")
                return
            }
            
            DispatchQueue.main.async {
                saveImageToDocumentDirectory(from: url)
            }
        }.resume()
    }
    
    class func saveImageToDocumentDirectory(from url: URL){
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            guard let imageData = data, let image = UIImage(data: imageData) else {
                print("Invalid image data")
                return
            }
            
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let imageFileURL = documentsURL?.appendingPathComponent("\(Date().timeIntervalSince1970).png")
            
            do {
                //saving the image into the document directory
                try imageData.write(to: imageFileURL!)
                print("Image saved to: \(imageFileURL?.path ?? "Unknown")")
            } catch {
                print("Error saving image: \(error)")
            }
        }.resume()
    }
    
    class func deleteAllImagesFromDocumentDirectory() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first

        do {
            // Get the URLs of all files in the document directory
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL!, includingPropertiesForKeys: nil, options: [])

            // Filter the image URLs (you can customize the condition based on your image file names or extensions)
            let imageFileURLs = fileURLs.filter { $0.pathExtension == "jpg" || $0.pathExtension == "png" }

            // Iterate through the image URLs and delete each file
            for imageURL in imageFileURLs {
                try fileManager.removeItem(at: imageURL)
            }
            
            print("All images deleted from the document directory.")
        } catch {
            print("Error deleting images: \(error)")
        }
    }
    
    class func showAlert(title: String, message: String, currentViewController : UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        currentViewController.present(alertController, animated: true)
    }
}
