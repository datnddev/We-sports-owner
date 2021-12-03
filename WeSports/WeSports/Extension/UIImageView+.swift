//
//  UIImageView.swift
//  WeSports
//
//  Created by datNguyem on 01/12/2021.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageUrl(path: String) {
        guard let url = URL(string: path) else { return }
        let imageCaches = ImageCacheManager.shared.imagesCache
        let key = NSString(string: path)
        
        if let cachedImage = imageCaches.value(for: key) {
            self.isHidden = false
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isHidden = false
                    self.image = image
                    imageCaches.insert(image, for: key)
                }
            }.resume()
        }
    }
}
