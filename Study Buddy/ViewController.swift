//
//  ViewController.swift
//  Study Buddy
//
//  Created by Micah Zirn on 5/16/16.
//  Copyright © 2016 Micah Zirn. All rights reserved.
//

import Cocoa

var currentDict : [String : String] = [:]
var fileDict : [String : [String : String]] = ["lammy": [:]]

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    
    @IBOutlet var tableCell: NSTableCellView!
    
    @IBOutlet var tableView: NSTableView!
    
    @IBOutlet var dropView: DropView!
    
    @IBOutlet var stackView: NSStackView!
    
    @IBOutlet var stackLabel: NSTextField!
    
    @IBOutlet var stackField: NSTextField!
   
    @IBOutlet var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        stackView.hidden = true
        tableView.doubleAction = Selector("rowClicked:")
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func rowClicked(sender: NSTableView)
    {
        let cell = sender.viewAtColumn(0, row: sender.clickedRow, makeIfNecessary: false) as! myCell
       currentDict = fileDict[cell.textf.stringValue]!
        print(currentDict)
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return fileDict.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("cell", owner: self) as! myCell
        var arr = Array(fileDict.keys).sort { $0 < $1 }
        cell.textf.stringValue = arr[row]
        cell.textf.alignment = NSTextAlignment.Left
        return cell
    }
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30.0
    }
}

