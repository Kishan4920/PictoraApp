
import Alamofire

class PixabayAPIManager {
    
    static let shared = PixabayAPIManager()
    private let apiKey = "38500238-4f3bc74ab19eac2577418025d"

    func fetchImages(completion: @escaping ([String]) -> Void) {
        let url = "https://pixabay.com/api/"
        let parameters: [String: Any] = [
            "key": apiKey,
            "q": "nature",
            "image_type": "photo"
        ]
        
        AF.request(url, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let hits = json["hits"] as? [[String: Any]] {
                    let imageUrls = hits.compactMap { $0["webformatURL"] as? String }
                    completion(imageUrls)
                }
            case .failure(let error):
                print("Error fetching images: \(error)")
                completion([])
            }
        }
    }
}
