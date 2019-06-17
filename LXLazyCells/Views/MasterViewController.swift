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
    var totalProducts  = 0
    let loadingView = UIView()
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()


    required init?(coder aDecoder: NSCoder) {
        dataController = DataController.sharedDataController
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        registerNotifications()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = dataController.item(for: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.totalProducts = self.totalProducts
                controller.detailItem = object
                controller.currentIndexPath  = indexPath
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    private func registerNotifications(){
        NotificationCenter.default.addObserver(forName: LazyCellConstants.initialFetchNotificationName, object: nil, queue: .main) { [weak self] (_) in
            guard let strongSelf = self else {return}
            if case .error = strongSelf.dataController.initialFetchStatus{
                strongSelf.showLoadingFailed()
            }else{
                guard case .success(Count: _) = strongSelf.dataController.initialFetchStatus else{
                    return
                }
                strongSelf.removeLoadingScreen()
                strongSelf.tableView.reloadData()
                let indexPathZero = IndexPath(row: 0, section: 0)
                strongSelf.detailViewController?.totalProducts = strongSelf.totalProducts
                strongSelf.detailViewController?.detailItem = strongSelf.dataController.item(for: indexPathZero)
                strongSelf.detailViewController?.currentIndexPath  = indexPathZero
            }
        }
    }

    func configureUI()  {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        setLoadingScreen()
    }

    func showLoadingFailed()  {
        let alert = UIAlertController(title: "Connection Error", message: "Not able to connect to server", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.style = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)

        tableView.addSubview(loadingView)
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
    }
}

// TableView methods
extension  MasterViewController{
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataController.initialFetchStatus{
        case .success(Count: let count):
            totalProducts = count
            return count
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LazyCellConstants.productCellID, for: indexPath) as!  ProductCell
        dataController.populateDataFor(container: cell, for: indexPath)
        return cell
    }

  
}
