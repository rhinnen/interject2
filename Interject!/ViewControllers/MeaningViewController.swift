//
//  MeaningViewController.swift
//  Interject!
//
//  Created by Rory Martin Hinnen on 11/22/18.
//  Copyright © 2018 Rory Hinnen. All rights reserved.
//

import UIKit

class MeaningView: UIViewController {
    
    var meaning: Entry? = nil
    var sfw = true
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let meaning = meaning {
            wordLabel.text = meaning.word(sfw).uppercaseFirst + ":"
            meaningLabel.text = meaning.define(sfw) + "."
        }
    }
}
