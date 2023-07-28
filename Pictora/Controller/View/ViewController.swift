//
//  ViewController.swift
//  Pictora
//
//  Created by Raaj Patel on 26/07/23.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController{

    //MARK: - Outlets & Variables
    @IBOutlet weak var btnGoogleSignIn: UIButton!
    
    
    //MARK: - Did load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    func setupUI(){
        self.btnGoogleSignIn.layer.cornerRadius = self.btnGoogleSignIn.frame.height / 2
    }
    
    
    //MARK: - Button Actions
    @IBAction func btnGoogleSignIn(_ sender: UIButton) {
        let nextVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        let presentingVC = ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController)!
        
        if !AppConstant.isNetworkAvailable(){
            AppConstant.showAlert(title: "", message: "Please check your internet connection", currentViewController: self)
            return
        }
        AppConstant.deleteAllImagesFromDocumentDirectory()
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC){ signInResult, error in
            guard let result = signInResult else {
                // Inspect error
                return
            }
            UserDefaults().setAuthenticationToken(value: "\(result.user.idToken)")
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}





