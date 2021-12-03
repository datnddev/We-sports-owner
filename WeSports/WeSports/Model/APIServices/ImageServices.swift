//
//  ImageServices.swift
//  WeSports
//
//  Created by datNguyem on 01/12/2021.
//

import Foundation
import UIKit

final class ImageServices {
    static let shared = ImageServices()
    private var imageMap = [UIImageView: UUID]()
    
    private init () {}
    
    func load(path: String, for imageView: UIImageView) {
        let taskID = APIManager.shared.loadImageURL(path: path) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    imageView.image = image
                }
            case .failure(let error):
                print(error)
            }
            self.imageMap.removeValue(forKey: imageView)
        }
        if let taskID = taskID {
            imageMap[imageView] = taskID
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let taskID = imageMap[imageView] {
            APIManager.shared.cancelTask(with: taskID)
            imageMap.removeValue(forKey: imageView)
        }
    }
}
