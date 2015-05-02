//
//  ViewController.swift
//  FoodTracker
//
//  Created by Koen Hendriks on 24/03/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

	@IBOutlet weak var tableView: UITableView!
	
	let kAppId = "b7cd4c25"
	let kAppKey = "97d859a57311bf9ccb81ffa444d03090"
	
	var searchController:UISearchController!
	
	var suggestedSearchFoods:[String] = []
	var filteredSuggestedSearchFoods:[String] = []
	
	var apiSearchForFoods:[(name: String, idValue: String)] = []
	
	var favoritedUSDAItems: [USDAItem] = []
	var filteredFavoritedUSDAItems:[USDAItem] = []
	
	var scopeButtonTitles = ["Recommended","Search Results","Saved"]
	
	var jsonResponse:NSDictionary!
	
	var dataController = DataController()
	
	
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
		// Determine how many rows we want to display in our tableView based on wether the user is using the search bar or not
		let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
		
		if selectedScopeButtonIndex == 0{
			if self.searchController.active{
				return self.filteredSuggestedSearchFoods.count
			}
			else{
				return self.suggestedSearchFoods.count
			}
		}
			
		else if selectedScopeButtonIndex == 1{
			return self.apiSearchForFoods.count
		}
			
		else{
			if self.searchController.active{
				return self.filteredFavoritedUSDAItems.count
			}
			else{
				return self.favoritedUSDAItems.count
			}
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
		var foodName:String
		
		let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
		
		// If we've got the first scope button selected, display the suggested search foods
		if selectedScopeButtonIndex == 0{
			if self.searchController.active{
				foodName = filteredSuggestedSearchFoods[indexPath.row]
			}
			else{
				foodName = suggestedSearchFoods[indexPath.row]
			}
		}
		
		else if selectedScopeButtonIndex == 1{
			foodName = apiSearchForFoods[indexPath.row].name
		}
		else{
			if self.searchController.active{
				foodName = self.filteredFavoritedUSDAItems[indexPath.row].name
			}
			else{
				foodName = self.favoritedUSDAItems[indexPath.row].name
			}
		}
		
		cell.textLabel?.text = foodName
		cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		
		return cell
	}
	
	// MARK: UITableViewDelegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
		
		if selectedScopeButtonIndex == 0{
			var searchFoodName:String
			
			if self.searchController.active{
				searchFoodName = filteredSuggestedSearchFoods[indexPath.row]
			}
			else{
				searchFoodName = suggestedSearchFoods[indexPath.row]
			}
			self.searchController.searchBar.selectedScopeButtonIndex = 1
			makeRequest(searchFoodName)
		}
		else if selectedScopeButtonIndex == 1{
			// Get the idValue of the selected item
			let idValue = apiSearchForFoods[indexPath.row].idValue
			// Save the selected item to CoreData
			self.dataController.saveUSDAItemForID(idValue, json: self.jsonResponse)
		}
		else if selectedScopeButtonIndex == 2{
			
		}
		
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
		if scope == 0{
			self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food : String) -> Bool in
				var foodMatch = food.lowercaseString.rangeOfString(searchText)
				return foodMatch != nil
			})
		}
		else if scope == 2{
			self.filteredFavoritedUSDAItems = self.favoritedUSDAItems.filter({ (item: USDAItem) -> Bool in
				var stringMatch = item.name.lowercaseString.rangeOfString(searchText)
				return stringMatch != nil
			})
		}
		
		
	}
	
	// MARK: - UISearchBarDelegate
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		self.searchController.searchBar.selectedScopeButtonIndex = 1
		makeRequest(searchBar.text)
	}
	
	func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		
		if selectedScope == 2{
			requestFavoritedUSDAItems()
		}
		
		self.tableView.reloadData()
	}
	
	
	func makeRequest(searchString : String){
		// Note to self: How to make a HTTP Get request
//		let url = NSURL(string: "\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppId)&appKey=\(kAppKey)")
//		
//		let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
//			var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//			println(stringData)
//			println(response)
//		})
//		task.resume()
		
		// How to make a HTTP Post request
		var request = NSMutableURLRequest(URL: NSURL(string: "https://api.nutritionix.com/v1_1/search/")!)
		
		let session = NSURLSession.sharedSession()
		request.HTTPMethod = "POST"
		// Params dictionary containing the parameters we want to submit
		var params = [
			"appId" : kAppId,
			"appKey" : kAppKey,
			"fields" : ["item_name","brand_name","keywords","usda_fields"],
			"limit" : "50",
			"query" : searchString,
			"filters" : ["exists" :["usda_fields" : true]]
		]
		
		var error: NSError?
		request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
			var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
			var conversionError:NSError?
			var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &conversionError) as? NSDictionary
			
			println(jsonDictionary)
			
			if conversionError != nil{
				println(conversionError!.localizedDescription)
				let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
				println("Error in Parsing \(errorString)")
			}
			else{
				if jsonDictionary != nil{
					self.jsonResponse = jsonDictionary!
					self.apiSearchForFoods = DataController.jsonAsUSDAIdAndNameSearchResults(jsonDictionary!)
					// Updat the UI on the main thread
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.tableView.reloadData()
					})
					
				}
				else{
					let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
					println("Error Could not parse JSON \(errorString)")
				}
			}
			
		})
		task.resume()
	}
	
	// MARK: - Setup CoreData
	func requestFavoritedUSDAItems () {
		let fetchRequest = NSFetchRequest(entityName: "USDAItem")
		let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
		let managedObjectContext = appDelegate.managedObjectContext
		self.favoritedUSDAItems = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [USDAItem]
	}
	

}





















