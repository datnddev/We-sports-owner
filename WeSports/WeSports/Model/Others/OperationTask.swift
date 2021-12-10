//
//  OperationTask.swift
//  WeSports
//
//  Created by datNguyem on 08/12/2021.
//

import Foundation

class OperationTask: Operation {
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isFinished: Bool {
        state == .finished
    }
    
    override var isExecuting: Bool {
        state == .executing
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
    }
    
    override func cancel() {
        state = .finished
    }
}

extension OperationTask {
    enum State: String {
        case ready
        case executing
        case finished
        
        var keyPath: String {
            "is\(rawValue.capitalized)"
        }
    }
}
