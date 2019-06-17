//
//  ProductResponseParser.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/8/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation
/*
 enum to parse and store the response on success
 error on failure
 */
enum ProductResponseParser {
    case error
    case succcess(totalProducts: Int, productsList: [ProductEntity])
    
    init(result: ResultType) {
        switch  result {
        case .failure( _):
            self =  .error
        case .success( _, let data):
            do{
                let parsedResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                self = .succcess(totalProducts: parsedResponse.totalProducts, productsList: parsedResponse.products)
            }catch{
                self = .error
            }

        }
    }
}
