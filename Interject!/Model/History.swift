//
//  data.swift
//  Interject! 2
//
//  Created by Rory Hinnen on 2/3/18.
//  Copyright © 2018 Rory Hinnen. All rights reserved.
//

import Foundation

// MARK:

// This is History. It's an array of sentences.
// In the code I limit the size of the array to 100 by dropping the oldest entries.
// It might be nice to make that part of this class
class History {
    var phrases = [Sentence]()
    var sfw = true
    
    init() {
        registerDefaults()
        handleFirstTime()
    }
    
    // MARK: Save Utilities
    // These are some untility funtions to make saving variables long term easier
    
    // Find a place to store files for later reading
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Let's name the path of the save file
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Interject.plist")
    }
    
    // Let's save the history of Sentences we've seen, in case we need them later
    func save() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(phrases)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    
    // Let's load the history of Sentences we've seen.
    func load() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                phrases = try decoder.decode([Sentence].self, from: data)
            } catch {
                print("Error decoding item array!")
            }
        }
    }
    
    // Let's set up our default User Vars
    func registerDefaults() {
        let dictionary: [String:Any] = ["SFW": true, "FirstTime": true ]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // Is this the first time we've run?
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        sfw = userDefaults.bool(forKey: "SFW")
        if firstTime {
            // Yes, it's the first time, so lets load up a new sentence
            phrases = [newSentence(oldSentence: Sentence.init())]
        } else {
            // Nope, we've been here before, let's get our history
            load()
        }
        //Ok, let's mark it so next time we know it's not the first time
        userDefaults.set(false, forKey: "FirstTime")
        userDefaults.synchronize()
    }
}



