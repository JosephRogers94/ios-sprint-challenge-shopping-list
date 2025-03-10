//
//  ShoppingList.swift
//  Shopping List
//
//  Created by Joseph Rogers on 10/13/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class ShoppingList {
    
    //MARK: Properties
    private(set) var items: [ShoppingItem] = [] //creates an empty array of items of type ShoppingItem
    
    private var shoppingListURL: URL? = { //creates the url and save file path
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documents.appendingPathComponent("shoppinglist.plist")
    }()
    
    //here we sheck if the item is in the list or not.
    var inList: [ShoppingItem] {
        let listed = items.filter { $0.inShoppingList == true }
        return listed
    }
    var notInList: [ShoppingItem] {
        let unlisted = items.filter { $0.inShoppingList == false }
        return unlisted
    }
    
    
    //here, whenever the class is initilized. we check the user defaults for any keys. if none are loaded from persistent storing, we call the new item names, and append them to shoppingItem.
    init() {
        if UserDefaults.standard.bool(forKey: "Initialized") {
            loadFromPersistentStore()
        } else {
            let itemNames = ["Apple", "Grapes", "Milk", "Muffin", "Popcorn", "Soda", "Strawberries"]
            for item in itemNames {
                items.append(ShoppingItem(name: item))
            }
            saveToPersistentStore()
            UserDefaults.standard.set(true, forKey: "Initialized")
        }
    }
    //here we just toggle the value of the item we are at.
    func toggleListed(item: ShoppingItem) {
        guard let itemNumber = items.firstIndex(of: item) else { return }
        items[itemNumber].inShoppingList.toggle()
    }
    
    
    // MARK: - File I/O
//here we are doing a generic save to and load to persistent store
    func saveToPersistentStore() {
        guard let url = shoppingListURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let itemsData = try encoder.encode(items)
            try itemsData.write(to: url)
        } catch {
            print(" \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        let fileManager = FileManager.default
        guard let url = shoppingListURL, fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodedItems = try decoder.decode([ShoppingItem].self, from: data)
            items = decodedItems
        } catch {
            print(" \(error)")
        }
    }
}
