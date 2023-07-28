//
//  SecondViewController.swift
//  Pictora
//
//  Created by Raaj Patel on 26/07/23.
//

import UIKit

class SecondViewController: UIViewController {

    //MARK: - Outlets & Variables
    @IBOutlet weak var clvPhotos : UICollectionView!
    @IBOutlet weak var loaderView: UIView! // Connect this to your loader view in the storyboard
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageUrls: [String] = []
    
    //MARK: - Did Load Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Custom Functions
    func setupUI(){
        self.setupCollectionView()
    }
    
    func setupCollectionView(){
        let cellSize = CGSize(width: self.clvPhotos.bounds.width  , height: self.clvPhotos.bounds.height)
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = cellSize
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.scrollDirection = .horizontal
        self.clvPhotos.showsHorizontalScrollIndicator = false
        self.clvPhotos.isPagingEnabled = true
        self.clvPhotos.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        self.clvPhotos.setCollectionViewLayout(flowLayout, animated: false)
        self.clvPhotos.allowsMultipleSelection = true
        self.clvPhotos.delegate = self
        self.clvPhotos.dataSource = self
        self.showLoader()
        self.fetchImagesFromPixabay()
    }
    
    func fetchImagesFromPixabay() {
        
        if !AppConstant.isNetworkAvailable(){
            self.hideLoader()
            AppConstant.showAlert(title: "", message: "Please check your internet connection", currentViewController: self)
            return
        }
        
        PixabayAPIManager.shared.fetchImages { [weak self] imageUrls in
            self?.imageUrls = imageUrls
            print(imageUrls)
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.clvPhotos.reloadData()
            }
        }
    }
    
    func showLoader() {
        self.loaderView.isHidden = false
        self.activityIndicator.startAnimating()
    }

    func hideLoader() {
        self.loaderView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    //MARK: - Button Actions
    @objc func btnDownloadImage(sender : UIButton) {
        if let url = URL(string: self.imageUrls[sender.tag]){
            AppConstant.loadImage(from: url)
        }
    }
    
    @IBAction func btnProfile(_ sender : UIButton){
        let nextVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func btnSavedImages(_ sender : UIButton){
        let nextVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SavedImagesViewController") as! SavedImagesViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - Collection View Delegate Methods
extension SecondViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.clvPhotos.dequeueReusableCell(withReuseIdentifier: "HomePhotosCollectionViewCell", for: indexPath) as! HomePhotosCollectionViewCell
        
        self.showLoader()
        if let imageUrl = URL(string: imageUrls[indexPath.row]) {
            self.hideLoader()
            cell.loadImage(from: imageUrl)
        }
        cell.btnDownload.layer.cornerRadius = iPad ? 15 : 5
        cell.btnSaveImage.tag = indexPath.row
        cell.btnSaveImage.addTarget(self, action: #selector(self.btnDownloadImage), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.clvPhotos.bounds.width, height: self.clvPhotos.bounds.height)
    }
}
