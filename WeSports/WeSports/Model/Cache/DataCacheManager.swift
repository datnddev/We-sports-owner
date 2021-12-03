//
//  DataCacheManager.swift
//  WeSports
//
//  Created by datNguyem on 01/12/2021.
//

import Foundation

final class DataCacheManager {
    var dataCache = Cache<NSString, Data>()
    
    static let shared = DataCacheManager()
    
    private init() { }
}
