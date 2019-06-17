//
//  Product.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/9/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation

/*
 Operaton to feth the products for page size- has threee states
 --Initaly ProductStatus is initalized with .notStarted state
 --When making API call it changes to .inProgress state, with its operation instance
 --When API is success(product), the Product is initalized and replaced with inprogress item in array
 */
enum ProductStatus{
    case notStarted
    case inProgress(Operation)
    case loaded(Product)

    init(_ product: Product){
        self = .loaded(product)
    }
}

class Product{
    private var entity: ProductEntity
    
    init(_ entity: ProductEntity) {
        self.entity = entity
    }
    
    var productName : String {
        return entity.productName ?? "No Name"
    }
    
    var price: String {
        return entity.price ?? "Price not available"
    }
    
    var reviewRating: Double {
        return entity.reviewRating ?? 0.0
    }
    
    var reviewCount: Int {
        return entity.reviewCount ?? 0
    }
    
    var inStock: Bool{
        return entity.inStock
    }
    
    var imageUrl: URL? {
        return URL(string: entity.productImage ?? String.emptyString, relativeTo: NetworkHandler.baseURL)!
    }
    
    var shortDescription: NSAttributedString? {
        guard let shortDescription = entity.shortDescription else {return nil}
        return convertToAttributedHTML(shortDescription)
    }
    
    var longDescription: NSAttributedString? {
        guard let longDescription = entity.longDescription else {return nil}
        return convertToAttributedHTML(longDescription)
    }
    
    private func convertToAttributedHTML(_ input: String) -> NSAttributedString? {
        if let inputData = input.data(using: .utf8),
            let attr = try? NSMutableAttributedString(
                data: inputData,
                options: [.documentType : NSAttributedString.DocumentType.html],
                documentAttributes: nil) {
            return attr as NSAttributedString
        }
        return nil
    }
}
