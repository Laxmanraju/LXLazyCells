//
//  ProductCell.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/9/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import UIKit

protocol  CellOperationConfidurable {
    func  configure(with product: ProductStatus)
    func  addOperation(op: Operation, dependingOn depOp:Operation)
    func  cancelPendingOperations()
}

class ProductCell: UITableViewCell, CellOperationConfidurable {
    
    func configure(with product: ProductStatus) {
        
    }
    
    func addOperation(op: Operation, dependingOn depOp: Operation) {
        
    }
    
    func cancelPendingOperations() {
        
    }
    
    
}
