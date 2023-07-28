//
//  SavedImagesViewController.swift
//  Pictora
//
//  Created by Raaj Patel on 27/07/23.
//

import UIKit

class SavedImagesViewController: UIViewController {

    //MARK: - Outlets & Variables
    @IBOutlet weak var lblNoImages: UILabel!
    @IBOutlet weak var clvSavedPhotos: UICollectionView!
    
    var imageFileURLs: [URL] = []
    
    //MARK: - Did load Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        setupCollectionView()
    }
    
    //MARK: - Custom Functions
    func setupCollectionView(){
        let cellSize = CGSize(width: (self.clvSavedPhotos.bounds.width / (iPad ? 4 : 2))  , height: (self.clvSavedPhotos.bounds.width / (iPad ? 4 : 2)) )
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = cellSize
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.scrollDirection = .vertical
        self.clvSavedPhotos.showsVerticalScrollIndicator = false
        self.clvSavedPhotos.isPagingEnabled = true
        self.clvSavedPhotos.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.clvSavedPhotos.setCollectionViewLayout(flowLayout, animated: false)
        self.clvSavedPhotos.allowsMultipleSelection = true
        self.clvSavedPhotos.delegate = self
        self.clvSavedPhotos.dataSource = self
        self.fetchImageFromDocumentDIrectory()
    }
    
    func fetchImageFromDocumentDIrectory(){
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                // Get the URLs of all files in the document directory
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
                
                // Filter the image URLs (you can customize the condition based on your image file names or extensions)
                imageFileURLs = fileURLs.filter { $0.pathExtension == "jpg" || $0.pathExtension == "png" }
                print(imageFileURLs)
                if imageFileURLs.count == 0{
                    self.lblNoImages.isHidden = false
                    self.clvSavedPhotos.isHidden = true
                }
                else{
                    self.lblNoImages.isHidden = true
                    self.clvSavedPhotos.isHidden = false
                    self.clvSavedPhotos.reloadData()
                }
                // Reload the collection view after obtaining the image file URLs
//                collectionView.reloadData()
            } catch {
                print("Error getting image file URLs: \(error)")
            }
        }
    }
    
    //MARK: - Button Actions
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Collection View Delegate Methods
extension SavedImagesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageFileURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.clvSavedPhotos.dequeueReusableCell(withReuseIdentifier: "SavedPhotosCollectionViewCell", for: indexPath) as! SavedPhotosCollectionViewCell
        
        let imageURL = imageFileURLs[indexPath.item]
        if let image = UIImage(contentsOfFile: imageURL.path) {
            cell.imgSavedPhoto.image = image
        }
        cell.imgSavedPhoto.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        nextVC.imageURl = self.imageFileURLs[indexPath.row]
        self.present(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.clvSavedPhotos.bounds.width / (iPad ? 4 : 2)), height: (self.clvSavedPhotos.bounds.width / (iPad ? 4 : 2)))
    }
}
