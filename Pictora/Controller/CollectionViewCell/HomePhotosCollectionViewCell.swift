//
//  HomePhotosCollectionViewCell.swift
//  Pictora
//
//  Created by Raaj Patel on 27/07/23.
//

import UIKit

class HomePhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnSaveImage : UIButton!
    @IBOutlet weak var btnDownload: UIButton!

    func loadImage(from url: URL){
        
        //downloading images through urlsession
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                return
            }
            
            DispatchQueue.main.async {
                self?.imgPhoto.image = image
            }
        }.resume()
    }
}
