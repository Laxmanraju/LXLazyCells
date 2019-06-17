//
//  NetworkOperation.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/7/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation
typealias ResultType = Result<(URLResponse, Data), Error>

class  NetworkOperation: Operation {    
    private var url: URL
    private var completion: ((ProductResponseParser) -> Void)
    private var sessionTask: URLSessionDataTask?
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    override var isAsynchronous: Bool {return true}

    // overide isFinished property to give it KVO capabilities
    // Purpose: to notify depeneding-operation completion of this operation
    private var _isFinished: Bool = false
    override var isFinished: Bool {
        get {
            return _isFinished
        }
        set (newAnswer) {
            willChangeValue(forKey: "isFinished")
            _isFinished = newAnswer
            didChangeValue(forKey: "isFinished")
        }
    }
    
    init(_ url: URL, completion: @escaping((ProductResponseParser) -> Void)){
        self.url = url
        self.completion = completion
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        sessionTask = session.dataTask(with: url) { (result) in
            if self.isCancelled {
                self.isFinished = true
                self.sessionTask?.cancel()
                return
            }
            switch result{
            case .success( _ , _):
                let parsedResponse = ProductResponseParser.init(result: result)
                self.completion(parsedResponse)
                self.isFinished = true
            default:
                break
            }
        }
        sessionTask?.resume()
    }
    
    override func cancel() {
        sessionTask?.cancel()
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (ResultType) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, reponse, error) in
            if let error = error{
                result(.failure(error))
                return
            }
            guard let response = reponse, let data = data else{
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
