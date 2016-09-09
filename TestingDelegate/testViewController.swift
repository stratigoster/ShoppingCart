//
//  testViewController.swift
//  TestingDelegate
//
//  Created by xszhao on 2016-04-12.
//  Copyright © 2016 xszhao. All rights reserved.
//

import UIKit

class testViewController: UIViewController, ShoppingCartViewControllerDelegate{
    func shoppingCartCloseButtonPressed(shoppingCartContent:[Item]?) {
        
        print("inside testViewControllerDelegate")
        //self.dismissViewControllerAnimated(true,  completion: nil)
    }

    override func viewDidLoad() {
        let shoppingCartVC: ShoppingCartViewController = (ShoppingCartViewController(nibName: nil, bundle: nil))
        //set the delegate so that the parent can respond to calls from ShoppingCartViewControllerDelegate
        //sort of like parent registers to events from ShoppingCartViewControllerDelegate
        shoppingCartVC.delegate = self
        shoppingCartVC.shoppingCartContent = []
        
        let navCon: UINavigationController = UINavigationController(rootViewController: shoppingCartVC)
        self.presentViewController(navCon, animated: true, completion: nil)
        
        //what happens when you don't override this?
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target:self, action: "backButtonAction:")
        
        print("view Pressed.")
    }
    
    //func backButtonAction(sender: UIBarButtonItem) {
    //    print("testViewController back button pressed")
    //    self.dismissViewControllerAnimated(true,  completion: nil)
    //}

}
