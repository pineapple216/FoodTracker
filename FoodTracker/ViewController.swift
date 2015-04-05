//
//  ViewController.swift
//  FoodTracker
//
//  Created by Koen Hendriks on 24/03/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

	@IBOutlet weak var tableView: UITableView!
	
	let kAppId = "b7cd4c25"
	let kAppKey = "97d859a57311bf9ccb81ffa444d03090"
	
	var searchController:UISearchController!
	
	var suggestedSearchFoods:[String] = []
	var filteredSuggestedSearchFoods:[String] = []
	
	var scopeButtonTitles = ["Recommended","Search Results","Saved"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController.searchResultsUpdater = self
		self.searchController.dimsBackgroundDuringPresentation = false
		self.searchController.hidesNavigationBarDuringPresentation = false
		
		// Set the size and position of the searchbar
		self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0)
		
		self.tableView.tableHeaderView = self.searchController.searchBar
		
		self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles
		self.searchController.searchBar.delegate = self
		
		self.definesPresentationContext = true
		
		// Array with suggested foods
		self.suggestedSearchFoods = ["apple", "bagel", "banana", "beer", "bread", "carrots", "cheddar cheese", "chicen breast", "chili with beans", "chocolate chip cookie", "coffee", "cola", "corn", "egg", "graham cracker", "granola bar", "green beans", "ground beef patty", "hot dog", "ice cream", "jelly doughnut", "ketchup", "milk", "mixed nuts", "mustard", "oatmeal", "orange juice", "peanut butter", "pizza", "pork chop", "potato", "potato chips", "pretzels", "raisins", "ranch salad dressing", "red wine", "rice", "salsa", "shrimp", "spaghetti", "spaghetti sauce", "tuna", "white wine", "yellow cake"]
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: UITableViewDataSource
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Determine how many rows we want to display in our tableView based wether the user is using the search bar or not
		if self.searchController.active{
			return self.filteredSuggestedSearchFoods.count
		}
		else{
			return self.suggestedSearchFoods.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
		var foodName:String
		
		if self.searchController.active{
			foodName = filteredSuggestedSearchFoods[indexPath.row]
		}
		else{
			foodName = suggestedSearchFoods[indexPath.row]
		}
		
		cell.textLabel?.text = foodName
		cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		
		return cell
	}

	// MARK: UISearchResultsUpdating
	
	// Function to update the search controllers results
	// is called everytime we change something in the search bar
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		let searchString = self.searchController.searchBar.text
		let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
		self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
		self.tableView.reloadData()
	}
	
	func filterContentForSearch(searchText: String, scope: Int){
		self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food : String) -> Bool in
			var foodMatch = food.rangeOfString(searchText)
			return foodMatch != nil
		})
	}
	
	// MARK: - UISearchBarDelegate
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		makeRequest(searchBar.text)
	}
	
	
	func makeRequest(searchString : String){
		// Note to self: How to make a HTTP Get request
//		let url = NSURL(string: "https://api.nutritionix.com/v1_1/search/\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppId)&appKey=\(kAppKey)")
//		
//		let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
//			var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//			println(stringData)
//			println(response)
//		})
//		task.resume()
	}
	

}





















