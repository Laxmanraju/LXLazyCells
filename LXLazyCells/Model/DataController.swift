//
//  DataController.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/6/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import UIKit

class DataController: NSObject {
    enum fetchStatus{
        case none
        case success(Count: Int)
        case error
    }
    
    private static let pageSize: Int = 8
    private let network: NetworkHandler
    public static let sharedDataController = DataController()
    var products: [ProductStatus] = []

    var initialFetchStatus = fetchStatus.none {
        didSet{
            NotificationCenter.default.post(Notification(name:LazyCellConstants.initialFetchNotificationName))
        }
    }
    override init() {
        self.network = NetworkHandler(pageSize: DataController.pageSize)
        super.init()
        initialFetch()
    }
    
    lazy var lazyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = QualityOfService.userInitiated
        return queue
    }()
    
    func initialFetch(){
        let indexPathZero = IndexPath(row: 0, section: 0)
        let initialOperation = network.operation(for: getPageForIndexPath(index: indexPathZero)) {[weak self] (result) in
            guard let strongSelf = self else { return }
            switch result{
            case .error:
                strongSelf.initialFetchStatus = .error
                return
            case .succcess(totalProducts: let totalCount, productsList: let products):
                self?.fetchCompleted(for: indexPathZero, with: products.map(Product.init))
                strongSelf.initialFetchStatus = .success(Count: totalCount)
                return
            }
        }
        markFetchInProgress(for: indexPathZero, with: initialOperation)
        lazyQueue.addOperation(initialOperation)
    }
    
    func populateDataFor(container : ContainerOperationConfigurable, for index: IndexPath)  {
        let state = self.fetchState(for: index)
        switch state {
        case .notStarted:
            container.configure(with: nil)
        case .inProgress(_):
            container.configure(with: nil)
        case .loaded(let product):
            container.configure(with: product)
        }
        
        switch state {
        case .notStarted:
            let currOperation = network.operation(for: getPageForIndexPath(index: index)) {[weak self] (result) in
                guard let strongSelf = self else {return}
                switch result{
                case .error:
                    strongSelf.initialFetchStatus = .error
                    return
                case .succcess(totalProducts: _, productsList: let products):
                    strongSelf.fetchCompleted(for: index, with: products.map(Product.init))
                }
            }
            markFetchInProgress(for: index, with: currOperation)
            lazyQueue.addOperation(currOperation)
            let updateOp = self.createUpdateOperation(for: container, at: index)
            container.addOperation(updateOp: updateOp, dependingOn: currOperation)
            
        case .inProgress(let currOp):
            print("Cell in progress \(index.row)")
            let updateOp = self.createUpdateOperation(for: container, at: index)
            container.addOperation(updateOp: updateOp, dependingOn: currOp)
        case .loaded(_):
            break
            
        }
    }
    
    func getPageForIndexPath(index: IndexPath) -> Int{
        return (index.row / DataController.pageSize) + 1
    }
    func  fetchState(for index: IndexPath) -> ProductStatus {
        if products.count <= index.row{
            let numbersToInsert = index.row - products.count + 1
            let notLoadedItems: [ProductStatus] = Array(repeating: .notStarted, count: numbersToInsert)
            products.append(contentsOf: notLoadedItems)
        }
        return products[index.row]
    }
    
    func markFetchInProgress(for indexPath: IndexPath, with operation: Operation){
        let inProgressItems :[ProductStatus] = Array(repeating: .inProgress(operation), count: DataController.pageSize)
        products.insert(contentsOf: inProgressItems, at: indexPath.row)

    }
    
    func fetchCompleted(for indexPath:IndexPath, with newProducts: [Product]){
        let range = indexPath.row..<indexPath.row+newProducts.count
        products.replaceSubrange(range, with: newProducts.map(ProductStatus.init))
    }
    
    func createUpdateOperation(for container:  ContainerOperationConfigurable, at index: IndexPath) -> Operation {
        return BlockOperation { [weak self] in
            guard let strongSelf = self ,case .loaded(let product) = strongSelf.fetchState(for: index) else
            {
                return
            }
            container.configure(with: product)
        }
    }
    
    func item(for index: IndexPath) -> Product? {
        if case .loaded(let product) = fetchState(for: index){
            return product
        }
        return nil
    }
}

