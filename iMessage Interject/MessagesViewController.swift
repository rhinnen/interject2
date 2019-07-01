//
//  MessagesViewController.swift
//  iMessage Interject
//
//  Created by Rory Hinnen on 11/18/18.
//  Copyright © 2018 Rory Hinnen. All rights reserved.
//

import UIKit
import Messages

extension String {
    var uppercaseFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

// This uses the Words Structure, it doesn't need History.
class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: UI VARS
    @IBOutlet weak var sfwLabel: UIBarButtonItem!
    @IBOutlet weak var phraseLabel: UILabel!
    
    
    // MARK: Local Vars
    var sfw = true
    var sentence = Sentence()
    
    
    // MARK: functions
    // first load, Let's explain what the need to do.
    override func viewDidLoad() {
        super.viewDidLoad()
        phraseLabel.text = "Swipe down for new words, up to send."
    }
    
    // Toggle sfw
    @IBAction func sfwToggle(_ sender: Any) {
        if !sfw {
            sfw = true
            sfwLabel.title = "SFW"
            updatePhraseLabel()
        } else {
            sfw = false
            sfwLabel.title = "NSFW"
            updatePhraseLabel()
        }
    }
    
    // Let's get a new phrase
    @IBAction func newPhrase(_ sender: Any) {
        sentence = newSentence(oldSentence: sentence)
        updatePhraseLabel()
    }
    
    // Send a phrase to messages
    @IBAction func sendPhrase(_ sender: Any) {
        let conversation = self.activeConversation
        conversation?.insertText(phraseLabel.text!) { error in }
    }
    
    // Update the label
    func updatePhraseLabel() {
        phraseLabel.text = sentence.adjective1.word(sfw).uppercaseFirst + " " + sentence.adjective2.word(sfw).uppercaseFirst + " " + sentence.noun.word(sfw).uppercaseFirst
    }
}
