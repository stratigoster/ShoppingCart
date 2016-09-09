//
//  ShoppingCartViewController.swift
//  ChangingTableViewController
//
//  Created by xszhao on 2016-01-03.
//  Copyright © 2016 xszhao. All rights reserved.
//

import UIKit

protocol ShoppingCartViewControllerDelegate {
    func shoppingCartCloseButtonPressed(ShoppingCartContent: [Item]?)
}

//ItemCellDelegate addds custom functionality to cell click for tableView.
//class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemCellDelegate {
    
    var delegate: ShoppingCartViewControllerDelegate?
    var shoppingCartTableView: UITableView?
    var shoppingCartContent: [Item]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.shoppingCartContent = []
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.shoppingCartContent = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //dummy data used to populate detail view.
        //self.shoppingCartContent = [Item(name: "iPhone 5S Silver 32GB", imageName: "iPhone5sSilver", price: 554.94)]
        self.setupSubviews()
        self.autolayoutSubviews()
        
        //default for all left button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target:self, action: #selector(ShoppingCartViewController.backButtonAction(_:)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews(){
        self.shoppingCartTableView = UITableView()
        self.shoppingCartTableView!.translatesAutoresizingMaskIntoConstraints = false
        self.shoppingCartTableView!.dataSource = self
        self.shoppingCartTableView!.delegate = self
        self.shoppingCartTableView!.estimatedRowHeight = 40.0
        self.shoppingCartTableView!.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(self.shoppingCartTableView!)
    }
    
    func autolayoutSubviews() {
        self.shoppingCartTableView!.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        self.shoppingCartTableView!.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        self.shoppingCartTableView!.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        self.shoppingCartTableView!.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingCartContent!.count
    }
    
    //check if code has bugs in it.
    //There's a bug in this code.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("itemCell") as? ItemCell
        
        if cell == nil {
            cell = ItemCell(style: .Default, reuseIdentifier: "itemCell", isShoppingCart: true)
            //set delegate for ItemCellDelegate. How do you know that this is different than ShoppingCartViewControllerDelegate?
            cell!.delegate = self
        }
        //force enable cells to be clickable. sometimes disabled when you recycle cells. 
        cell!.switchCellState(false)
        let item = self.shoppingCartContent![indexPath.row]
        cell!.item = item
        return cell!
    }
    
    func backButtonAction(sender: UIBarButtonItem) {
        print("shoppingCartBackButtonPressed")
        self.dismissViewControllerAnimated(true,  completion: nil)
        
        //what is the content in shoppingCartContent?
        self.delegate?.shoppingCartCloseButtonPressed(self.shoppingCartContent)
    }
    
    //ItemCellDelegate called after you want to remove
    func itemCellButtonPressed(item: Item?, isShoppingCart:Bool) {
        print("shoppingCart")
        print(isShoppingCart)
        if item != nil && isShoppingCart == true {
            let itemIndex: Int? = shoppingCartContent!.indexOf(item!)
            if itemIndex != nil {
                self.shoppingCartContent!.removeAtIndex(itemIndex!)
                self.shoppingCartTableView!.deleteRowsAtIndexPaths([NSIndexPath(forRow: itemIndex!, inSection: 0)], withRowAnimation: .Automatic)
            }
        }
    }
}
