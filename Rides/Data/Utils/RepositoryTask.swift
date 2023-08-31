//
//  RepositoryTask.swift
//  Rides
//
//  Created by Sameh Farouk on 31/08/2023.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
