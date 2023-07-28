//
//  ProfileViewController.swift
//  Pictora
//
//  Created by Raaj Patel on 27/07/23.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController{
    
    //MARK: - Outlets & Variables
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblUserEmail : UILabel!
    
    //MARK: - Did load Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.getProfile()
        self.imgProfile.layer.cornerRadius = iPad ? 125 : 75
        self.lblUserEmail.text = GIDSignIn.sharedInstance.currentUser?.profile?.email
        self.lblUserName.text = GIDSignIn.sharedInstance.currentUser?.profile?.name
    }
    
    //MARK: - Custom Functions
    func getProfile(){
        if let profilePicURL = GIDSignIn.sharedInstance.currentUser?.profile!.imageURL(withDimension: 200) {
            // Fetch the profile picture from the URL
            URLSession.shared.dataTask(with: profilePicURL) { data, _, error in
                if let error = error {
                    print("Error downloading profile picture: \(error.localizedDescription)")
                    return
                }
                if let data = data, let profileImage = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        self.imgProfile.image = profileImage
                    }
                    // Use the profileImage as needed
                    // You can display it in an UIImageView, save it locally, etc.
                }
            }.resume()
        }
    }
    
    //MARK: - Button Actions
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signOut()
        AppConstant.deleteAllImagesFromDocumentDirectory()
        AppConstant.showAlert(title: "Pictora", message: "User Signed Out Successfully", currentViewController: self)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.authenticationToken.rawValue)
        // Redirecting to HomeViewController
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let newNav : UINavigationController = UINavigationController.init(rootViewController: vc)
        newNav.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = newNav
    }
}
