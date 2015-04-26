//
//  DataController.swift
//  FoodTracker
//
//  Created by Koen Hendriks on 11/04/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController{
	
	class func jsonAsUSDAIdAndNameSearchResults(json:NSDictionary) -> [(name: String, idValue: String)]{
		
		var usdaItemsSearchResults:[(name: String, idValue: String)] = []
		var searchResult:(name: String, idValue: String)
		
		if json["hits"] != nil{
			let results:[AnyObject] = json["hits"]! as! [AnyObject]
			
			for itemDictionary in results{
				if itemDictionary["_id"] != nil{
					if itemDictionary["fields"] != nil{
						let fieldsDictionary = itemDictionary["fields"] as! NSDictionary
						if fieldsDictionary["item_name"] != nil{
							let idValue:String = itemDictionary["_id"]! as! String
							let name:String = fieldsDictionary["item_name"]! as! String
							searchResult = (name : name, idValue: idValue)
							usdaItemsSearchResults += [searchResult]
						}
					}
				}
			}
		}
		return usdaItemsSearchResults
	}
	
	func saveUSDAItemForID(idValue:String, json:NSDictionary){
		// Check is our hits variable in our JSON isn't nill and iterate over the dictionary.
		if json["hits"] != nil{
			let results:[AnyObject] = json["hits"]! as! [AnyObject]
			
			for itemDictionary in results{
				// Check that the id matches the idValue we passed in to our function
				if itemDictionary["_id"] != nil && itemDictionary["_id"] as! String == idValue{
					
					let managedObjectContext = (UIApplication .sharedApplication().delegate as!AppDelegate).managedObjectContext
					
					var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
					
					let itemDictionaryId = itemDictionary["_id"]! as! String
					let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
					requestForUSDAItem.predicate = predicate
					
					var error:NSError?
					
					// Execute our request
					var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
					
					if items?.count != 0{
						// The item is already saved
						return
					}
					else{
						println("Lets save this to CoreData!")
					}
					
				}
			}
		}
	}
	
	
	
}


















