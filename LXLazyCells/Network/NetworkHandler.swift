//
//  NetworkHandler.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/7/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation

public class NetworkHandler {
    var pageSize: Int
    
    init(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    public static var baseURL : URL {
        return URL(string: "https://mobile-tha-server.firebaseapp.com")!
    }
    
    func operation(for page: Int, completion: @escaping ((ProductResponseParser) -> Void)) -> Operation {
        return NetworkOperation(getUrlforPage(pageNumber: page), completion:completion )
    }
    
    /*Get URL specific to the partial tableview page load*/
    private func getUrlforPage(pageNumber: Int) -> URL {
        let pathForPage = "/walmartproducts/\(pageNumber)/\(pageSize)"
        return URL(string: pathForPage, relativeTo: NetworkHandler.baseURL)!
    }

}

