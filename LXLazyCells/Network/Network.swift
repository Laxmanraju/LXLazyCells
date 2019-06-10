//
//  Network.swift
//  WalmartDebugPractice
//
//  Created by Laxman Penmesta on 6/5/19.
//  Copyright © 2019 com.laxman. All rights reserved.
//

import Foundation

protocol NetworkResponseInitializable {
    init(with data: Data?, response: URLResponse?, error: Error?)
}


public class Network {
    
    private let pageSize: Int
    
    init(pageSize: Int) {
        self.pageSize = pageSize
    }
    
//    func operation(forPage page: Int, completion: @escaping((ProductPageResult) -> Void)) -> Operation {
//        return NetworkOperation(urlForPage(page), completion: completion)
//    }
    
    private static var baseUrl: URL {
        return URL(string: "https://mobile-tha-server.firebaseapp.com")!
    }
    
    private func urlForPage(_ pageNumber: Int) -> URL{
        let pathForPage = "/walmartproducts/\(pageNumber)/\(pageSize)"
        return URL(string: pathForPage, relativeTo: Network.baseUrl)!
    }
    
    static func urlForImage(_ imageURL: String) -> URL{
        return URL(string: imageURL, relativeTo: Network.baseUrl)!
    }
}

