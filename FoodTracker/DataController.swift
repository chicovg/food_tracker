//
//  DataController.swift
//  FoodTracker
//
//  Created by Victor Guthrie on 7/21/15.
//  Copyright (c) 2015 chicovg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let kUSDAItemSaved = "USDAItemSaved"

class DataController {
    
    class func jsonAsUSDAIdAndNameSearchResults(json : NSDictionary) -> [(name: String, idValue: String)] {
        var usdaItemsSearchResults: [(name: String, idValue: String)] = []
        var searchResult: (name: String, idValue: String)
        
        if json["hits"] != nil {
            let results: [AnyObject] = json["hits"] as! [AnyObject]
            
            for itemDictionary in results {
                if itemDictionary["_id"] != nil {
                    if itemDictionary["fields"] != nil {
                        let fieldsDictionary = itemDictionary["fields"] as! NSDictionary
                        if fieldsDictionary["item_name"] != nil {
                            let idValue: String = itemDictionary["_id"] as! String
                            let name: String = fieldsDictionary["item_name"] as! String
                            searchResult = (name: name, idValue: idValue)
                            usdaItemsSearchResults += [searchResult]
                        }
                    }
                }
            }
        }
        return usdaItemsSearchResults
    }
    
    func saveUSDAItemForId(idValue: String, json: NSDictionary) {
        if json["hits"] != nil {
            let results: [AnyObject] = json["hits"]! as! [AnyObject]
            
            for itemDictionary in results {
                if itemDictionary["_id"] != nil && itemDictionary["_id"] as! String == idValue {
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                    
                    var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
                    
                    let itemDictionaryId = itemDictionary["_id"]! as! String
                    let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
                    
                    requestForUSDAItem.predicate = predicate
                    
                    var error: NSError?
                    var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
                    
                    if items?.count != 0 {
                        // The item is already saved
                        println("The Item was already saved")
                        return
                    } else {
                        println("Saving to CoreData ...")
                        
                        let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext!)
                        let usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
                        usdaItem.idValue = itemDictionary["_id"] as! String
                        usdaItem.dateAdded = NSDate()
                        
                        if itemDictionary["fields"] != nil {
                            let fieldsDictionary = itemDictionary["fields"]! as! NSDictionary
                            if fieldsDictionary["item_name"] != nil {
                                usdaItem.name = fieldsDictionary["item_name"]! as! String
                            }
                            
                            if fieldsDictionary["usda_fields"] != nil && !(fieldsDictionary["usda_fields"] is NSNull) {
                                let usdaFieldsDictionary = fieldsDictionary["usda_fields"]! as! NSDictionary
                                if usdaFieldsDictionary["CA"] != nil {
                                    let calciumDictionary = usdaFieldsDictionary["CA"]! as! NSDictionary
                                    if calciumDictionary["value"] != nil {
                                        let calciumValue: AnyObject = calciumDictionary["value"]!;
                                        usdaItem.calcium = "\(calciumValue)"
                                    }
                                } else {
                                    usdaItem.calcium = "0"
                                }
                                
                                if usdaFieldsDictionary["CHOCHF"] != nil {
                                    let carbohydrateDictionary = usdaFieldsDictionary["CHOCHF"]! as! NSDictionary
                                    if carbohydrateDictionary["value"] != nil {
                                        let carbohydrateValue: AnyObject = carbohydrateDictionary["value"]!;
                                        usdaItem.carbohydrate = "\(carbohydrateValue)"
                                    }
                                } else {
                                    usdaItem.carbohydrate = "0"
                                }
                                
                                if usdaFieldsDictionary["FAT"] != nil {
                                    let fatDictionary = usdaFieldsDictionary["FAT"]! as! NSDictionary
                                    if fatDictionary["value"] != nil {
                                        let fatValue: AnyObject = fatDictionary["value"]!;
                                        usdaItem.fatTotal = "\(fatValue)"
                                    }
                                } else {
                                    usdaItem.fatTotal = "0"
                                }
                                
                                if usdaFieldsDictionary["CHOLE"] != nil {
                                    let cholesterolDictionary = usdaFieldsDictionary["CHOLE"]! as! NSDictionary
                                    if cholesterolDictionary["value"] != nil {
                                        let cholesterolValue: AnyObject = cholesterolDictionary["value"]!;
                                        usdaItem.cholesterol = "\(cholesterolValue)"
                                    }
                                } else {
                                    usdaItem.cholesterol = "0"
                                }
                                
                                if usdaFieldsDictionary["PROCNT"] != nil {
                                    let proteinDictionary = usdaFieldsDictionary["PROCNT"]! as! NSDictionary
                                    if proteinDictionary["value"] != nil {
                                        let proteinValue: AnyObject = proteinDictionary["value"]!;
                                        usdaItem.protein = "\(proteinValue)"
                                    }
                                } else {
                                    usdaItem.protein = "0"
                                }
                                
                                if usdaFieldsDictionary["SUGAR"] != nil {
                                    let sugarDictionary = usdaFieldsDictionary["SUGAR"]! as! NSDictionary
                                    if sugarDictionary["value"] != nil {
                                        let sugarValue: AnyObject = sugarDictionary["value"]!;
                                        usdaItem.sugar = "\(sugarValue)"
                                    }
                                } else {
                                    usdaItem.sugar = "0"
                                }
                                
                                if usdaFieldsDictionary["VITC"] != nil {
                                    let vitaminCDictionary = usdaFieldsDictionary["VITC"]! as! NSDictionary
                                    if vitaminCDictionary["value"] != nil {
                                        let vitaminCValue: AnyObject = vitaminCDictionary["value"]!;
                                        usdaItem.vitaminC = "\(vitaminCValue)"
                                    }
                                } else {
                                    usdaItem.vitaminC = "0"
                                }
                                
                                if usdaFieldsDictionary["ENERC_KCAL"] != nil {
                                    let energyDictionary = usdaFieldsDictionary["ENERC_KCAL"]! as! NSDictionary
                                    if energyDictionary["value"] != nil {
                                        let energyValue: AnyObject = energyDictionary["value"]!;
                                        usdaItem.energy = "\(energyValue)"
                                    }
                                } else {
                                    usdaItem.energy = "0"
                                }
                                
                                (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                                NSNotificationCenter.defaultCenter().postNotificationName(kUSDAItemSaved, object: usdaItem)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
