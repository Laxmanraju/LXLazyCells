//
//  MasterViewController.swift
//  LXLazyCells
//
//  Created by Laxman Penmesta on 6/6/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import UIKit
import Kingfisher

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var dataController: DataController
    

    required init?(coder aDecoder: NSCoder) {
        dataController = DataController.sharedDataController
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        navigationItem.leftBarButtonItem = editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        registerNotifications()
        registerCells()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    private func registerNotifications(){
        NotificationCenter.default.addObserver(forName: LazyCellConstants.initialFetchNotificationName, object: nil, queue: .main) { [weak self] (_) in
            guard let strongSelf = self else {return}
            guard case .success(Count: let count) = strongSelf.dataController.initialFetchStatus else{
                strongSelf.showLoadingFailed()
                return
            }
            strongSelf.tableView.reloadData()
        }
    }
    
    func registerCells()  {
        tableView.register(UINib(nibName: LazyCellConstants.productCellID, bundle: nil), forCellReuseIdentifier: LazyCellConstants.productCellID)
    }
    
    func configureUI()  {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 140
    }
    
    func showLoadingFailed()  {
        
    }
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataController.initialFetchStatus{
        case .success(Count: let count):
            return count
        default:
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LazyCellConstants.productCellID, for: indexPath) as!  ProductCell
        dataController.populate(cell: cell, for: indexPath)
        return cell
    }

}
