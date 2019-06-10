//
//  ProductResponseParser.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/8/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation

enum ProductResponseParser:ResponseParsable {
    case error
    case succcess(totalProducts: Int, productsList: [ProductEntity])
    
    init(result: ResultType) {
        switch  result {
        case .failure(let error):
//            print(error)
            self =  .error
        case .success(let response, let data):
            do{
                let parsedResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
                self = .succcess(totalProducts: parsedResponse.totalProducts, productsList: parsedResponse.products)
            }catch{
//                print("Decoding Error ")
                self = .error
            }
//            print(response, data)

        }
    }
}