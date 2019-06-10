//
//  ProductCell.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/9/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import UIKit
import Kingfisher


protocol  CellOperationConfigurable {
    func  configure(with product: Product?)
    func  addOperation(updateOp: Operation, dependingOn currOp:Operation)
    func  cancelPendingOperations()
}


class ProductCell: UITableViewCell, CellOperationConfigurable {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var specialDetailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    private weak var operation: Operation?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetCell()
        cancelPendingOperations()
    }
    
    func configure(with product: Product?) {
        guard let product = product else {
            configureWithPlaceHolder()
            return
        }
        productNameLabel.text = product.productName
        productNameLabel.font = UIFont.LXBook(size: LazyCellConstants.titleFontSize)
        priceLabel.text = product.price
        priceLabel.font = UIFont.LXBook(size: LazyCellConstants.titleFontSize)
//        specialDetailsLabel.attributedText = product.shortDescription
        ratingLabel.text = "Rating \(product.reviewRating)/5 (\(product.reviewCount) \(product.reviewCount > 1 ? "reveiws": "review"))"
        ratingLabel.font = UIFont.LXLight(size: LazyCellConstants.titleFontSize)
        productImageView?.kf.setImage(with: product.imageUrl)
        self.setNeedsLayout()
    }
    
    private func resetCell(){
        productNameLabel.text = " "
        priceLabel.text = " "
        specialDetailsLabel.text = " "
        ratingLabel.text = " "
        productImageView.image = nil
        
    }
    
    func configureWithPlaceHolder()  {
        productNameLabel.text = " "
        priceLabel.text = " "
        specialDetailsLabel.text = " "
        ratingLabel.text = " "
    }
    
    func addOperation(updateOp: Operation, dependingOn currOp: Operation) {
        if let _  = operation{
            cancelPendingOperations()
        }
        updateOp.addDependency(currOp)
        operation = updateOp
        OperationQueue.main.addOperation(updateOp)
    }
    
    func cancelPendingOperations() {
        operation?.cancel()
    }
 
}
