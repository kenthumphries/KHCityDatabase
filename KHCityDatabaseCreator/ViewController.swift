//
//  ViewController.swift
//  KHCityDatabaseCreator
//
//  Created by Kent Humphries on 11/01/2016.
//  Copyright © 2016 HumpBot. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var resultTextField: NSTextField!
    @IBOutlet weak var showInFinderButton: NSButton!
    
    var databaseURL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func generateDatabase(sender: AnyObject) {

        guard let sender = sender as? NSButton else {
            return
        }
        
        sender.enabled = false
        showInFinderButton.hidden = true
        
        defer {
            sender.enabled = true
            self.resultTextField.sizeToFit()
            self.view.needsLayout = true
            self.view.setNeedsDisplayInRect(self.view.bounds)
        }
        
        do {
            let databaseURL = try KHCityRealmCreator().generatePopulatedRealmDatabase()
            
            self.resultTextField.stringValue = self.resultTextField.stringValue + databaseURL.absoluteString
            
            self.databaseURL = databaseURL
            showInFinderButton.hidden = false
        }
        catch let error as NSError {
            self.resultTextField.stringValue = "Error: " + error.description
        }
    }

    @IBAction func revealInFinder(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs([databaseURL])
    }
}

