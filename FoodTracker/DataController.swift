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

let kUSDAItemCompleted = "USDAItemInstanceComplete"

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
						println("The item was already saved")
						return
					}
					// The item is not already saved to CoreData, lets create a new usdaItem and start saving it's attributes
					else{
						println("Lets save this to CoreData!")
						
						let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext!)
						
						// Create a USDAItem
						let usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
						
						usdaItem.idValue = itemDictionary["_id"]! as! String
						usdaItem.dateAdded = NSDate()
						
						if itemDictionary["fields"] != nil{
							let fieldsDictionary = itemDictionary["fields"]! as! NSDictionary
							
							// Get our item_name
							if fieldsDictionary["item_name"] != nil{
								usdaItem.name = fieldsDictionary["item_name"]! as! String
							}
							
							if fieldsDictionary["usda_fields"] != nil{
								let usdaFieldsDictionary = fieldsDictionary["usda_fields"]! as! NSDictionary
								
								// Get the calcium value of the item
								if usdaFieldsDictionary["CA"] != nil{
									let calciumDictionary = usdaFieldsDictionary["CA"]! as! NSDictionary
									let calciumValue: AnyObject = calciumDictionary["value"]!
									usdaItem.calcium = "\(calciumValue)"
								}
								else{
									usdaItem.calcium = "0"
								}
								
								// Get the carbohydrates value of the item
								if usdaFieldsDictionary["CHOCDF"] != nil{
									let carbohydrateDictionary = usdaFieldsDictionary["CHOCDF"]! as! NSDictionary
									if carbohydrateDictionary["value"] != nil{
										let carbohydrateValue: AnyObject = carbohydrateDictionary["value"]!
										usdaItem.carbohydrate = "\(carbohydrateValue)"
									}
								}
								else{
									usdaItem.carbohydrate = "0"
								}
								
								// Get the FAT attribute of the item
								if usdaFieldsDictionary["FAT"] != nil{
									let fatTotalDictionary = usdaFieldsDictionary["FAT"]! as! NSDictionary
									if fatTotalDictionary["value"] != nil{
										let fatTotalValue:AnyObject = fatTotalDictionary["value"]!
										usdaItem.fatTotal = "\(fatTotalValue)"
									}
								}
								else{
									usdaItem.fatTotal = "0"
								}
								
								// Cholesterol Grouping
								if usdaFieldsDictionary["CHOLE"] != nil {
									let cholesterolDictionary = usdaFieldsDictionary["CHOLE"]! as! NSDictionary
									if cholesterolDictionary["value"] != nil {
										let cholesterolValue: AnyObject = cholesterolDictionary["value"]!
										usdaItem.cholesterol = "\(cholesterolValue)"
									}
								}
								else {
									usdaItem.cholesterol = "0"
								}
								
								// Protein Grouping
								if usdaFieldsDictionary["PROCNT"] != nil {
									let proteinDictionary = usdaFieldsDictionary["PROCNT"]! as! NSDictionary
									if proteinDictionary["value"] != nil {
										let proteinValue: AnyObject = proteinDictionary["value"]!
										usdaItem.protein = "\(proteinValue)"
									}
								}
								else {
									usdaItem.protein = "0"
								}
								
								// Sugar Total
								if usdaFieldsDictionary["SUGAR"] != nil {
									let sugarDictionary = usdaFieldsDictionary["SUGAR"]! as! NSDictionary
									if sugarDictionary["value"] != nil {
										let sugarValue:AnyObject = sugarDictionary["value"]!
										usdaItem.sugar = "\(sugarValue)"
									}
								}
								else {
									usdaItem.sugar = "0"
								}
								// Vitamin C
								if usdaFieldsDictionary["VITC"] != nil {
									let vitaminCDictionary = usdaFieldsDictionary["VITC"]! as! NSDictionary
									if vitaminCDictionary["value"] != nil {
										let vitaminCValue: AnyObject = vitaminCDictionary["value"]!
										usdaItem.vitaminC = "\(vitaminCValue)"
									}
								}
								else {
									usdaItem.vitaminC = "0"
								}
								// Energy
								if usdaFieldsDictionary["ENERC_KCAL"] != nil {
									let energyDictionary = usdaFieldsDictionary["ENERC_KCAL"]! as! NSDictionary
									if energyDictionary["value"] != nil {
										let energyValue: AnyObject = energyDictionary["value"]!
										usdaItem.energy = "\(energyValue)"
									}
								}
								else {
									usdaItem.energy = "0"
								}
								
								// Actually save the usdaItem we just created to CoreData
								(UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
								
								NSNotificationCenter.defaultCenter().postNotificationName(kUSDAItemCompleted, object: usdaItem)
								
							}
						}
					}
				}
			}
		}
	}
	
	
	
}


















