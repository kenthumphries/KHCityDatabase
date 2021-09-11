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
    
    var databaseURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func generateDatabase(_ sender: AnyObject) {

        guard let sender = sender as? NSButton else {
            return
        }
        
        sender.isEnabled = false
        showInFinderButton.isHidden = true
        
        defer {
            sender.isEnabled = true
            self.resultTextField.sizeToFit()
            self.view.needsLayout = true
            self.view.setNeedsDisplay(self.view.bounds)
        }
        
        do {
            let databaseURL = try KHCityCoreDataCreator().generatePopulatedCoreData()
            
            self.resultTextField.stringValue = "Database Path: " + databaseURL.absoluteString
            
            self.databaseURL = databaseURL
            showInFinderButton.isHidden = false
        }
        catch let error as NSError {
            self.resultTextField.stringValue = "Error: " + error.description
        }
    }

    @IBAction func revealInFinder(_ sender: AnyObject) {
        if let databaseURL = databaseURL {
            NSWorkspace.shared.activateFileViewerSelecting([databaseURL])
        }
    }
}

