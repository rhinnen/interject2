//
//  ViewController.swift
//  Interject! 
//
//  Created by Rory Hinnen on 2/3/18.
//  Copyright © 2018 Rory Hinnen. All rights reserved.
//

import UIKit

extension String {
    var uppercaseFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

class InterjectView: UIViewController {

    // MARK: UI VARS
    @IBOutlet weak var adjective1: UILabel!
    @IBOutlet weak var adjective2: UILabel!
    @IBOutlet weak var noun: UILabel!
    @IBOutlet weak var sfwButton: UIBarButtonItem!
    
    // We need to keep track of which words are locked, so they don't update
    // when we roll up a new sentence. We define the structure then use it.
    struct Locked {
        var adjective1, adjective2, noun: Bool
    }
    var locked = Locked(adjective1: false, adjective2: false, noun: false)
    
    // How big are we going to let the history variable grow
    let historySize = 100
    
    // MARK: Make up our variables
    var meaning: Entry!
    var history: History!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        print("in viewDidLoad")
        super.viewDidLoad()
        displayWords()
        if history.sfw {
            sfwButton.title = "SFW"
        } else {
            sfwButton.title = "NSFW"
        }
    }
    
    // MARK: Get ready to hand off in case someone doesn't know what a word means.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MeaningView" {
            if let mv = segue.destination as? MeaningView {
                // We need to know what word we're going to define
                // and the current state of sfw
                mv.meaning = meaning
                mv.sfw = history.sfw
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: sfw toggle
    @IBAction func sfwAction(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if history.sfw {
            sfwButton.title = "NSFW"
            history.sfw = false
        } else {
            sfwButton.title = "SFW"
            history.sfw = true
        }
        userDefaults.set(history.sfw, forKey: "SFW")
        userDefaults.synchronize()
        displayWords()
    }
    
    // MARK: pull new or back through old words
    @IBAction func swipeNewWords(_ sender: Any) {
        history.phrases.insert(updateWords(), at: 0)
        // this is where I've abitrarily set the size of history. It's sort of a
        // kluge. It might be nice to make this part of the history class, and the
        // size would be a size is something that history is initialized with.
        if history.phrases.count > historySize {
            history.phrases.remove(at: history.phrases.count-1)
        }
        displayWords()
    }
    
    @IBAction func swipeUpOldWords(_ sender: Any) {
        if history.phrases.count > 1 {
            let oldSentence = history.phrases[0]
            history.phrases.remove(at: 0)
            history.phrases[0] = lockedWords(oldSentence: oldSentence, newSentence: history.phrases[0])
            displayWords()
        }
    }
    
    // MARK: Locking functions
    @IBAction func lockAdj1(_ sender: Any) {
        let labelSize = adjective1.font.pointSize
        if locked.adjective1 {
            locked.adjective1 = false
            adjective1.font = UIFont(name: "AmericanTypewriter-Semibold", size: labelSize)

        } else {
            locked.adjective1 = true
            adjective1.font = UIFont(name: "AmericanTypewriter-Bold", size: labelSize)
        }
    }
    
    @IBAction func lockAdj2(_ sender: Any) {
        let labelSize = adjective2.font.pointSize
        if locked.adjective2 {
            locked.adjective2 = false
            adjective2.font = UIFont(name: "AmericanTypewriter-Semibold", size: labelSize)
        } else {
            locked.adjective2 = true
            adjective2.font = UIFont(name: "AmericanTypewriter-Bold", size: labelSize)
        }
    }
    
    @IBAction func lockNoun(_ sender: Any) {
        let labelSize = noun.font.pointSize
        if locked.noun {
            locked.noun = false
            noun.font = UIFont(name: "AmericanTypewriter-Semibold", size: labelSize)
        } else {
            locked.noun = true
            noun.font = UIFont(name: "AmericanTypewriter-Bold", size: labelSize)
        }
    }
    
    // MARK: Meaning segue
    
    // can I collapse these three functions into one? that would be better code.
    @IBAction func meaningAdj1(_ sender: Any) {
        meaning = history.phrases[0].adjective1
        self.performSegue(withIdentifier: "MeaningView", sender: self)
    }
    
    @IBAction func meaningAdj2(_ sender: Any) {
        meaning = history.phrases[0].adjective2
        self.performSegue(withIdentifier: "MeaningView", sender: self)
    }
    
    @IBAction func meaningNoun(_ sender: Any) {
        meaning = history.phrases[0].noun
        self.performSegue(withIdentifier: "MeaningView", sender: self)
    }
    
    // MARK: Utility functions
    
    /* func findMeaning(_ entry: Entry) -> String {
        let meaning = entry.word(history.sfw).uppercaseFirst + ":\n" + entry.define(history.sfw) + "."
        return meaning
    } */
    
    func updateWords() -> Sentence {
        let sentence = newSentence(oldSentence: history.phrases[0])
        return lockedWords(oldSentence: history.phrases[0], newSentence: sentence)
    }
    
    func lockedWords(oldSentence: Sentence, newSentence: Sentence) -> Sentence {
        let adjective1 = locked.adjective1 ? oldSentence.adjective1 : newSentence.adjective1
        let adjective2 = locked.adjective2 ? oldSentence.adjective2 : newSentence.adjective2
        let noun = locked.noun ? oldSentence.noun : newSentence.noun
        return(Sentence(adjective1: adjective1, adjective2: adjective2, noun: noun))
    }
    
    func displayWords() {
        adjective1.text = history.phrases[0].adjective1.word(history.sfw).uppercaseFirst
        adjective2.text = history.phrases[0].adjective2.word(history.sfw).uppercaseFirst
        noun.text = history.phrases[0].noun.word(history.sfw).uppercaseFirst
    }
    
    @IBAction func share(_ sender: Any) {
        let currentWords = history.phrases[0]
        let shareText = currentWords.adjective1.word(history.sfw).uppercaseFirst + " " + currentWords.adjective2.word(history.sfw).uppercaseFirst + " " + currentWords.noun.word(history.sfw).uppercaseFirst
        let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
        present(vc, animated: true)
    }
}
