//
//  DetailViewController.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/6/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import UIKit
/*Kingfisher framework for image caching operation*/
import Kingfisher

class DetailViewController: UIViewController, UIGestureRecognizerDelegate, ContainerOperationConfigurable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var shortDescLabel: UILabel!
    @IBOutlet weak var lognDescLabel: UILabel!
    @IBOutlet weak var inStockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    private weak var operation: Operation?
    // When new product is set, reload the page automatically
    var detailItem: Product? {
        didSet{
            if self.viewIfLoaded?.window != nil {
                configureView()
            }
        }
       
    }

    var currentIndexPath: IndexPath!
    var product: Product?
    var dataController =  DataController.sharedDataController
    var totalProducts = 0
    private lazy var rightSwipe: UIGestureRecognizer = {
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.swipeAction(_:)))
        swipeGestureRight.delegate = self
        swipeGestureRight.direction = .right
        return swipeGestureRight
    }()
    
    private lazy var leftSwipe: UIGestureRecognizer = {
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.swipeAction(_:)))
        swipeGestureLeft.delegate = self
        swipeGestureLeft.direction = .left
        return swipeGestureLeft
    }()
    
    func configureView() {
        if let detail = detailItem {
            resetView()
            DispatchQueue.main.async {
                self.nameLabel.text = detail.productName
                self.nameLabel.font = UIFont.LXBook(size: LazyCellConstants.headingFontSize)
                self.productImageView.kf.setImage(with:detail.imageUrl)
                self.ratingLabel.text = "Rating \(detail.reviewRating.getCleanDecimalString())/5 (\(detail.reviewCount) \(detail.reviewCount > 1 ? "reveiws": "review"))"
                self.ratingLabel.font = UIFont.LXMedium(size: LazyCellConstants.bodyFontSize)
                self.shortDescLabel.attributedText = detail.shortDescription
                self.shortDescLabel.font = UIFont.LXBook(size: LazyCellConstants.bodyFontSize)
                self.lognDescLabel.attributedText = detail.longDescription
                self.lognDescLabel.font = UIFont.LXBook(size: LazyCellConstants.bodyFontSize)
                self.inStockLabel.text = detail.inStock ? "In stock" : "Out of stock"
                self.priceLabel.text = detail.price
                self.priceLabel.font = UIFont.LXBold(size: LazyCellConstants.titleFontSize)
                self.inStockLabel.textColor = detail.inStock ? UIColor.LXBlue() : UIColor.LXGrey()
                self.inStockLabel.font = UIFont.LXLight(size: LazyCellConstants.subTitleFontSize)
                self.view.layoutSubviews()
            }
        }
    }

    func  resetView()  {
        self.nameLabel.text = String.emptyString
        self.productImageView.image  = nil
        self.ratingLabel.text = String.emptyString
        self.shortDescLabel.attributedText = nil
        self.lognDescLabel.attributedText = nil
        self.priceLabel.text = String.emptyString
        self.inStockLabel.text = String.emptyString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetView()
        configureView()
        addGestureRecognizers()
    }

    func addGestureRecognizers(){
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    /*
        Swipe action
        On swipe to unloaded item index, fetch operation is initated automatically for next page size
        on next page fetch, detail view UI is reloaded
     */
    @objc private func swipeAction(_ sender: UIGestureRecognizer){
        guard let sender = sender as? UISwipeGestureRecognizer else{
            return
        }
        if sender.direction == .right{
            guard currentIndexPath.row >= 1 else { return }
            if let nextproduct = dataController.item(for: IndexPath(row: currentIndexPath.row - 1, section: currentIndexPath.section)){
                currentIndexPath.row = currentIndexPath.row - 1
                detailItem = nextproduct
            }
        }else if sender.direction == .left{
            let newIndex = IndexPath(row: currentIndexPath.row + 1, section: currentIndexPath.section)
            guard newIndex.row < totalProducts else { return }
            if let prevproduct = dataController.item(for: newIndex){
               detailItem = prevproduct
            }else{
                dataController.populateDataFor(container: self, for: newIndex)
            }
            currentIndexPath.row = newIndex.row
        }else{
            print("Unwanted swipe")
        }
    }
    
    func configure(with product: Product?) {
        self.detailItem = product
    }
    /*
     Creating a dependency operation to Upadte UI (configureView())
     after the fetching data operation is completed
     */
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

