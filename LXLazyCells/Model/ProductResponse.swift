//
//  ProductResponse.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/8/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation
//Models to decode the reponse data
struct ProductResponse: Decodable {
    let products : [ProductEntity]
    let totalProducts : Int
    let pageNumber : Int
    let pageSize : Int
    let statusCode : Int
}

struct ProductEntity: Decodable, Equatable {
    let productId : String?
    let productName : String?
    let shortDescription : String?
    let longDescription : String?
    let price : String?
    let productImage : String?
    let reviewRating : Double?
    let reviewCount : Int?
    let inStock : Bool
}

