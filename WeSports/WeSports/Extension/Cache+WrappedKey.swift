//
//  Cache+WrappedKey.swift
//  WeSports
//
//  Created by datNguyem on 18/11/2021.
//

import Foundation

extension Cache {
    final class WrappedKey {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
    }
}
