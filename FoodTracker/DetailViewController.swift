//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Koen Hendriks on 27/03/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	var usdaItem:USDAItem?
	
	@IBOutlet weak var textView: UITextView!
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	deinit{
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func usdaItemDidComplete(notification: NSNotification){
		println("usdaItemDidComplete in DetailViewController")
		usdaItem = notification.object as? USDAItem
	}
	

	@IBAction func eatItBarButtonItemPressed(sender: UIBarButtonItem) {
	}

	

}
