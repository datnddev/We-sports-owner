//
//  Cache.swift
//  WeSports
//
//  Created by datNguyem on 18/11/2021.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    
    var cache: NSCache<WrappedKey, Entry>
    
    init() {
        cache = NSCache<WrappedKey, Entry>()
        cache.countLimit = 40
    }
}
