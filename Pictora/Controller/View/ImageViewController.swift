//
//  ImageViewController.swift
//  Pictora
//
//  Created by Raaj Patel on 28/07/23.
//

import UIKit

class ImageViewController: UIViewController {

    //MARK: - Outlets & Variables
    @IBOutlet weak var imgView: UIImageView!
    
    var imageURl = URL(string: "")
    
    //MARK: - Did load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        // Load the image from the URL
        guard let imageData = try? Data(contentsOf: self.imageURl!), let image = UIImage(data: imageData) else {
            print("Error loading the image from URL: \(self.imageURl)")
            return
        }
        self.imgView.image = image
    }
    
    //MARK: - Custom Functions
    func shareImage() {
        // Create an array containing the image you want to share
        let activityItems: [Any] = [self.imgView.image]
        
        // Initialize the UIActivityViewController with the activity items
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // Set excluded activity types if you want to limit the sharing options
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .openInIBooks,
            .airDrop,
            .copyToPasteboard,
            .mail
            // Add any other activity types you want to exclude
        ]
        
        // Present the UIActivityViewController
        present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - Button Actions
    @IBAction func btnShare(_ sender: UIButton) {
        self.shareImage()
    }
    
    @IBAction func btnDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
