//
//  ProductCell.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/9/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import UIKit
/*Kingfisher framework for image caching operation*/
import Kingfisher

/*
 Protocol to confirm to, to enable the reload of container(tableViewCell/DetailedView) elemetns after their content is fetched
 */
protocol  ContainerOperationConfigurable {
    func  configure(with product: Product?)
    func  addOperation(updateOp: Operation, dependingOn currOp:Operation)
    func  cancelPendingOperations()
}


class ProductCell: UITableViewCell, ContainerOperationConfigurable {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var specialDetailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    private weak var operation: Operation?

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
        priceLabel.font = UIFont.LXBold(size: LazyCellConstants.titleFontSize)
        specialDetailsLabel.attributedText = product.shortDescription
        specialDetailsLabel.font = UIFont.LXBook(size: LazyCellConstants.subTitleFontSize)
        ratingLabel.text = "Rating \(product.reviewRating.getCleanDecimalString())/5 (\(product.reviewCount) \(product.reviewCount > 1 ? "reveiws": "review"))"
        ratingLabel.textColor = UIColor.LXGrey()
        ratingLabel.font = UIFont.LXMedium(size: LazyCellConstants.bodyFontSize)
        productImageView?.kf.setImage(with: product.imageUrl)
        self.setNeedsLayout()
    }
    
    private func resetCell(){
        productNameLabel.text = String.emptyString
        priceLabel.text = String.emptyString
        specialDetailsLabel.text = String.emptyString
        ratingLabel.text = String.emptyString
        productImageView.image = nil
    }
    
    func configureWithPlaceHolder()  {
        productNameLabel.text = String.emptyString
        priceLabel.text = String.emptyString
        specialDetailsLabel.text = String.emptyString
        ratingLabel.text = String.emptyString
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
