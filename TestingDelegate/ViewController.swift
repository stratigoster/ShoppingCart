//
//  ViewController.swift
//  TestingDelegate
//
//  Created by xszhao on 2016-01-04.
//  Copyright © 2016 xszhao. All rights reserved.
//

import UIKit

//This class presents a series of rows with buttons to toggle selection
//It sends selected information to
//there is a cell delegate being implemented in parent tableview

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemCellDelegate, ShoppingCartViewControllerDelegate {
//class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //programmatically create UITableView
    var tableView: UITableView?
    
    //model object for current screen
    var tableViewContent: [Item]?
    
    //model object for the connection to the other screen
    var shoppingCartContent: [Item]?
    
    //what is a NSCoder?
    //no need for this anymore
    required init?(coder aDecoder: NSCoder) {
        print("init")
        super.init(coder: aDecoder)
    }
    
    //why do I need to specify the nibName?
    //no errors
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        print("init")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //in storyboard set current screen navigation board to be
    override func viewDidLoad() {
        print("viewDidLoad")
        print(self.navigationController)
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableViewContent = self.demoData()
        self.shoppingCartContent = []
        self.setupSubviews()
        self.autolayoutSubviews()
        
        /*
        let imageName = "shoppingCartEmpty"
        let image = UIImage(named: imageName)
        let face: UIButton = UIButton.buttonWithType(UIButtonType.Custom)
        face.bounds = CGRectMake(0, 0,
        */
        
        //http://www.placecage.com/40/40
        
        //imageWithrederingMode.AlwaysOriginal returns the original image icon instead of a blue square.
        let imagePhoto: UIImage? = UIImage(named:"shoppingCartEmpty")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imagePhoto, style: .Plain, target: self, action: #selector(ViewController.shoppingCartAction(_:)))
    }
    
    func demoData() -> [Item] {
        let iphone5sSilver32: Item = Item(name: "iPhone 5S Silver 32 GB", imageName: "iPhone5sSilver", price: 554.94, Id: 1)
        let iphone5sSpacegray32: Item = Item(name: "iPhone 5S Spacegray 32GB", imageName: "iPhone5sSpacegray", price: 554.94, Id: 2)
        let iphone6sSilver64: Item = Item(name: "iPhone 6S Silver 64 GB", imageName: "iPhone6sSilver", price: 854.96, Id: 3)
        let iphone6sSpacegray64: Item = Item(name: "iPhone 6S Space gray 64 GB", imageName: "iPhone6sSpacegray", price: 854.96, Id: 4)
        let iphone6sGold64: Item = Item(name: "iPhone 6S Gold 64GB", imageName: "iPhone6sGold", price: 854.96, Id: 5)
        let iphone6sRosegold64: Item = Item(name: "iPhone 6S Rosegold 64Gb", imageName: "iPhone6sRosegold", price: 854.96, Id: 6)
        return [iphone5sSilver32, iphone5sSpacegray32, iphone6sSilver64, iphone6sSpacegray64, iphone6sGold64, iphone6sRosegold64]
    }
    
    func setupSubviews() {
        self.tableView = UITableView()
        //allows you to programmatically set layout constraints
        self.tableView!.translatesAutoresizingMaskIntoConstraints = false
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        self.tableView!.estimatedRowHeight = 40.0
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(self.tableView!)
    }
    
    //makes the tableView take up the whole screen
    //the top anchor represents the top edge of the view
    func autolayoutSubviews() {
        self.tableView!.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        self.tableView!.leadingAnchor.constraintEqualToAnchor(self.view.leadingAnchor).active = true
        self.tableView!.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor).active = true
        self.tableView!.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
    }
    
    func shoppingCartAction(sender: UIBarButtonItem) {
        //create a new instance of the children view controller
        let shoppingCartVC: ShoppingCartViewController = (ShoppingCartViewController(nibName: nil, bundle: nil))
        //set the delegate so that the parent can respond to calls from ShoppingCartViewControllerDelegate
        //sort of like receiver registers to events from ShoppingCartViewControllerDelegate sender
        shoppingCartVC.delegate = self
        //populate the model object of children.
        shoppingCartVC.shoppingCartContent = self.shoppingCartContent
        //presents the view controller on click
        let navCon: UINavigationController = UINavigationController(rootViewController: shoppingCartVC)
        self.presentViewController(navCon, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewContent!.count
    }
    
    //creates each row.
    //gets called every time you need to display a new cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ItemCell? = tableView.dequeueReusableCellWithIdentifier("itemCell") as? ItemCell
        //if first time creating a cell aka the cell is not inflated
        if cell == nil {
            cell = ItemCell(style: .Default, reuseIdentifier: "ItemCell", isShoppingCart: false)
            cell!.delegate = self
        }
        
        let item = self.tableViewContent![indexPath.row]
        //is it in the shoppingCartContent?
        let itemIndex: Int? = shoppingCartContent!.indexOf(item)
        //check if item is previously selected or not
        itemIndex != nil ? cell!.switchCellState(true):cell!.switchCellState(false)
        cell!.item = item
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ItemCellDelegate
    func itemCellButtonPressed(item:Item?, isShoppingCart:Bool) {
        //false means parent view and has Add functionality
        //true means child view and has remove functionality
        if item != nil && isShoppingCart == false {
            self.shoppingCartContent!.append(item!)
            let imagePhoto: UIImage? = UIImage(named:"shoppingCartEmpty")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imagePhoto, style: .Plain, target: self, action: #selector(ViewController.shoppingCartAction(_:)))
        }
    }
    
    //ShoppingCartViewControllerDelegate to be used as the close button by the inner viewController
    //shoppingCartContent not being called
    func shoppingCartCloseButtonPressed(shoppingCartContent:[Item]?) {
        print("viewController handling delegate")
        var setNew = Set<Item>()
        for a: Item in shoppingCartContent! {
            setNew.insert(a)
        }

        var setOld = Set<Item>()
        for a: Item in self.shoppingCartContent! {
            setOld.insert(a)
        }
        
        var setDiff = Set<Item>()
        setDiff = setOld.subtract(setNew)
        
        self.shoppingCartContent = shoppingCartContent == nil ? [] : shoppingCartContent
        
        for it: Item in setDiff {
            let itemIndex = tableViewContent!.indexOf(it)
            let indexPath = NSIndexPath(forRow: itemIndex!, inSection: 0)
            print(indexPath.row)
            self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
        
        
        /*
        if self.shoppingCartContent!.count == 0 {
            let imagePhoto: UIImage? = UIImage(named:"shoppingCartEmpty")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imagePhoto, style: .Plain, target: self, action: "shoppingCartAction:")
        }
*/
        
        //tableView?.reloadData() //not efficient maybe use sets to only reload cells that changed
        
        
        //only reloads the cells that are visible in the screen
        //indexPathForCell can return nil when cell is not visible.
        //only visible cells in parent view
        
    }
}

