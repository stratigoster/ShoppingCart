//
//  ItemCell.swift
//  ChangingTableViewController
//
//  Created by xszhao on 2016-01-03.
//  Copyright © 2016 xszhao. All rights reserved.
//

import UIKit

//this delegate protocol will be called elsewhere, it represents the item to be displayed in navigation view.
protocol ItemCellDelegate {
    func itemCellButtonPressed(item: Item?, isShoppingCart: Bool)
}

//UITableViewCell implements NSCoding so it means you can implement it in storyboard?

//therefore, the init(coder: aDecoder) initializer is required by the NSCoding protocol, which means you need to implement it

//swift also makes sure all your class's properties are assigned a value in init() before making a call to super.init()
//you also can't define a common setup method to place duplicated code into all inits because you can't call super init
//you also can't move the call to self.setup above the call to super.init(), because you're not allowed to reference self until after 
//the class is fully initialized by calling super.init()
class ItemCell: UITableViewCell {
    
    //new delegate
    var delegate: ItemCellDelegate?
    
    //this is the base model of the custom cell. 
    var item: Item? {
        //what is didSet? gets called after ItemCell.item gets called
        //this is set here due to reuse see prepareForReuse
        didSet {
            if item != nil {
                self.itemImageView!.image = UIImage(named:item!.imageName)
                self.itemNameLabel!.text = item!.name
                self.itemPriceLabel!.text = "\(item!.price) "
            }
        }
    }
    
    var itemImageView: UIImageView?
    var itemNameLabel: UILabel?
    var itemPriceLabel: UILabel?
    var itemAddToShoppingCartButton: UIButton?
    var isShoppingCart: Bool = false
    
    //why is there code duplication in constructor? why do we need the override and required constructor?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = .None
        self.setupSubviews()
        self.autolayoutSubviews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.setupSubviews()
        self.autolayoutSubviews()
    }

    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, isShoppingCart: Bool) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        self.isShoppingCart = isShoppingCart
        self.selectionStyle = .None
        self.setupSubviews()
        self.autolayoutSubviews()
    }
    
    //called from within init(style: UITableViewCellStyle, reuseIdentifier: String?, isShoppingCart: Bool)
    func setupSubviews() {
        self.itemImageView = UIImageView()
        self.itemImageView!.translatesAutoresizingMaskIntoConstraints = false
        self.itemImageView!.contentMode = .ScaleAspectFit
        self.itemImageView!.clipsToBounds = true
        self.contentView.addSubview(self.itemImageView!)
        
        self.itemNameLabel = UILabel()
        self.itemNameLabel!.translatesAutoresizingMaskIntoConstraints = false
        self.itemNameLabel!.numberOfLines = 0
        self.contentView.addSubview(self.itemNameLabel!)
        
        self.itemPriceLabel = UILabel()
        self.itemPriceLabel!.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.itemPriceLabel!)
        
        self.itemAddToShoppingCartButton = UIButton(type: .System)
        self.itemAddToShoppingCartButton!.translatesAutoresizingMaskIntoConstraints = false
        self.itemAddToShoppingCartButton!.setTitle(isShoppingCart ? "Remove" : "Add", forState: .Normal)
        print("isShoppingCart is: ")
        print(isShoppingCart)
        self.itemAddToShoppingCartButton!.addTarget(self, action: #selector(ItemCell.addButtonPressedAction(_:)), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(self.itemAddToShoppingCartButton!)
    }
    
    func autolayoutSubviews() {
        //leadingAnchor and trailing Anchor are the same thigns, they determine the relationship between two views
        //the two views could be side by side
        //the two views can one inside another in this case 
        //setting the itemImageView as the leadingAnchor means the self.contentView will be the trailing anchor
        //does leadingAnchor mean left? Yes
        //determines the left distance
        
        //read more at NSLayoutAnchor class
        self.itemImageView!.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: 25.0).active = true
        self.itemImageView!.topAnchor.constraintGreaterThanOrEqualToAnchor(self.contentView.topAnchor, constant: 5.0).active = true
        self.itemImageView!.bottomAnchor.constraintLessThanOrEqualToAnchor(self.contentView.bottomAnchor, constant: -5.0).active = true
        self.itemImageView!.centerYAnchor.constraintEqualToAnchor(self.contentView.centerYAnchor).active = true
        
        self.itemImageView!.widthAnchor.constraintEqualToConstant(50.0).active = true
        
        self.itemNameLabel!.leadingAnchor.constraintEqualToAnchor(self.itemImageView!.trailingAnchor, constant: 15.0).active = true
        self.itemNameLabel!.topAnchor.constraintGreaterThanOrEqualToAnchor(self.contentView.topAnchor, constant: 55.0).active = true
        self.itemNameLabel!.bottomAnchor.constraintLessThanOrEqualToAnchor(self.contentView.bottomAnchor, constant: -55.0).active = true
        self.itemNameLabel!.centerYAnchor.constraintEqualToAnchor(self.contentView.centerYAnchor).active = true
        self.itemNameLabel!.setContentHuggingPriority(200, forAxis: .Horizontal)
        
        self.itemPriceLabel!.leadingAnchor.constraintEqualToAnchor(self.itemNameLabel!.trailingAnchor, constant: 15.0).active = true
        self.itemPriceLabel!.topAnchor.constraintGreaterThanOrEqualToAnchor(self.contentView.topAnchor, constant: 5.0).active = true
        self.itemPriceLabel!.bottomAnchor.constraintLessThanOrEqualToAnchor(self.contentView.bottomAnchor, constant: -5.0).active = true
        self.itemPriceLabel!.centerYAnchor.constraintEqualToAnchor(self.contentView.centerYAnchor).active = true
        
        self.itemAddToShoppingCartButton!.leadingAnchor.constraintEqualToAnchor(self.itemPriceLabel!.trailingAnchor, constant: 15.0).active = true
        
        self.itemAddToShoppingCartButton!.topAnchor.constraintGreaterThanOrEqualToAnchor(self.contentView.topAnchor, constant: 5.0).active = true
        
        self.itemAddToShoppingCartButton!.bottomAnchor.constraintLessThanOrEqualToAnchor(self.contentView.bottomAnchor, constant: -5.0).active = true
        
        self.itemAddToShoppingCartButton!.centerYAnchor.constraintEqualToAnchor(self.contentView.centerYAnchor).active = true
        self.itemAddToShoppingCartButton!.trailingAnchor.constraintEqualToAnchor(self.contentView.trailingAnchor, constant: -15.0).active = true
    }
    
    override func prepareForReuse() {
        self.itemImageView!.image = nil
        self.itemNameLabel!.text = ""
        self.itemPriceLabel!.text = ""
        self.itemAddToShoppingCartButton!.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.itemAddToShoppingCartButton!.userInteractionEnabled = false
    }
    
    /* If a UITableViewCell object is reusable—that is, it has a reuse identifier—this method is invoked just before the object is returned from the UITableView method 
    */
    //button click handler called when you want to remove and when you want to add?
    //should not be the same as removing
    func addButtonPressedAction(sender: UIButton) {
        //should only be called when you are adding instead of removing
        if isShoppingCart == false {
            self.switchCellState(true)
        }
        //now calls any classes that are registered to receive this
        self.delegate?.itemCellButtonPressed(self.item, isShoppingCart: self.isShoppingCart)
    }
    //called only from parent view itemcell
    func switchCellState(disable: Bool) {
        if disable == true {
            self.itemAddToShoppingCartButton!.setTitleColor(UIColor.brownColor(), forState: .Normal)
            self.itemAddToShoppingCartButton!.userInteractionEnabled = false
        }
        if disable == false {
            self.itemAddToShoppingCartButton!.userInteractionEnabled = true
            self.itemAddToShoppingCartButton!.setTitleColor(UIColor.blueColor(), forState: .Normal)
        }
    }
}
