//
//  Loader.swift
//  ImageLoader
//
//  Created by Hirohisa Kawasaki on 5/2/16.
//  Copyright © 2016 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Foundation

/**
 Responsible for sending a request and receiving the response and calling blocks for the request.
 */
open class Loader {

    unowned let delegate: Manager
    let task: URLSessionDataTask
    var receivedData = NSMutableData()
    var blocks: [Block] = []

    init (task: URLSessionDataTask, delegate: Manager) {
        self.task = task
        self.delegate = delegate
        resume()
    }

    var state: URLSessionTask.State {
        return task.state
    }

    open func completionHandler(_ completionHandler: @escaping CompletionHandler) -> Self {
        let identifier = (blocks.last?.identifier ?? 0) + 1
        return self.completionHandler(identifier, completionHandler: completionHandler)
    }

    open func completionHandler(_ identifier: Int, completionHandler: @escaping CompletionHandler) -> Self {
        let block = Block(identifier: identifier, completionHandler: completionHandler)
        return appendBlock(block)
    }

    func appendBlock(_ block: Block) -> Self {
        blocks.append(block)
        return self
    }

    // MARK: task

    open func suspend() {
        task.suspend()
    }

    open func resume() {
        task.resume()
    }

    open func cancel() {
        task.cancel()
    }

    func remove(_ identifier: Int) {
        // needs to queue with sync
        blocks = blocks.filter{ $0.identifier != identifier }
    }

    func receive(_ data: Data) {
        receivedData.append(data)
    }

    func complete(_ error: NSError?, completionHandler: @escaping () -> Void) {

        if let URL = task.originalRequest?.url {
            if let error = error {
                failure(URL, error: error, completionHandler: completionHandler)
                return
            }

            delegate.decompressingQueue.async { [weak self] in
                guard let wSelf = self else {
                    return
                }

                wSelf.success(URL, data: wSelf.receivedData as Data, completionHandler: completionHandler)
            }
        }
    }

    fileprivate func success(_ URL: Foundation.URL, data: Data, completionHandler: () -> Void) {
        let image = UIImage.decode(data)
        _toCache(URL, data: data)

        for block in blocks {
            block.completionHandler(URL, image, nil, .none)
        }
        blocks = []
        completionHandler()
    }

    fileprivate func failure(_ URL: Foundation.URL, error: NSError, completionHandler: () -> Void) {
        for block in blocks {
            block.completionHandler(URL, nil, error, .none)
        }
        blocks = []
        completionHandler()
    }

    fileprivate func _toCache(_ URL: Foundation.URL, data: Data?) {
        if let data = data {
            delegate.cache[URL] = data
        }
    }
}
