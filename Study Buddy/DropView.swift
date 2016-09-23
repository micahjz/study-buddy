//
//  DropView.swift
//  Study Siri
//
//  Created by Micah Zirn on 5/14/16.
//  Copyright © 2016 Micah Zirn. All rights reserved.
//

import Cocoa
import AVFoundation
import CoreData

class DropView: NSView {
    
    var filePath: String?
    let expectedExt = "docx"
    var progressBar = NSProgressIndicator()
    var dict = [:]
    var success = false
    var read = Read(a: NSAttributedString())
    
    @IBOutlet var label : NSTextField!
    @IBOutlet var stack : NSStackView!
    @IBOutlet var tableView : NSTableView!
    @IBOutlet var nameField : NSTextField!
    @IBAction func nameEntered(sender: AnyObject) {
        if !stack.hidden
        {
            fileDict[(sender as! NSTextField).stringValue] = dict as! [String : String]
            saveFile(dict as! [String : String])
            nameField.stringValue = ""
            stack.hidden = true
            label.hidden = false
            label.stringValue = "Drag and drop your word file"
            tableView.reloadData()
            dict = [:]
            success = false
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.grayColor().CGColor
        
        registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType])
        
        getFile()
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        if let pasteboard = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let path = pasteboard[0] as? String {
                let ext = NSURL(fileURLWithPath: path).pathExtension
                if ext == expectedExt {
                    self.layer?.backgroundColor = NSColor.blueColor().CGColor
                    return NSDragOperation.Copy
                }
            }
        }
        return NSDragOperation.None
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.grayColor().CGColor
    }
    
    override func draggingEnded(sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.grayColor().CGColor
        if success{
            initProgressBar(read.attrString.string)
            loadingData()
            parseData(read, pi: progressBar)
        }
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        if let pasteboard = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let path = pasteboard[0] as? String {
                self.filePath = path
                //GET YOUR FILE PATH !!
                let attrString = try! NSAttributedString.init(URL: NSURL(fileURLWithPath: path), options: [:], documentAttributes: nil)
                read = Read(a: attrString)
                success = true
            }
        }
        return false
    }
    func initProgressBar(str: String)
    {
        progressBar = NSProgressIndicator(frame: NSRect(x: (self.frame.width/2)-100, y: (self.frame.height/2)-10, width: 200, height: 20))
        progressBar.doubleValue = 0.0
        progressBar.maxValue = Double(str.characters.count)
        progressBar.hidden = false
        self.addSubview(progressBar)
        progressBar.startAnimation(self)
    }
    func saveFile(dict : [String : String])
    {
        let moc = AppDelegate().managedObjectContext
        var d = NSEntityDescription.insertNewObjectForEntityForName("Dictionary", inManagedObjectContext: moc)
        d.setValue(nameField.stringValue, forKey: "name")
        var manyRelation = d.valueForKeyPath("pairs") as! NSMutableSet
        for key in Array(dict.keys)
        {
            let p = NSEntityDescription.insertNewObjectForEntityForName("Pair", inManagedObjectContext: moc)
            p.setValue(dict[key], forKey: "definition")
            p.setValue(key, forKey: "word")
            manyRelation.addObject(p)
        }
        do {
            try moc.save()
        }
        catch{
            
        }
    }
    func getFile()
    {
        let moc = AppDelegate().managedObjectContext
        
        let fetch : NSFetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Dictionary", inManagedObjectContext: moc)
        fetch.entity = entity
        do
        {
            let result = try moc.executeFetchRequest(fetch)
            Swift.print("---")
            Swift.print(result.valueForKey("pairs"))
        }
        catch
        {
            
        }
    }
    func loadingData()
    {
        label.stringValue = "loading data..."
    }
    func parseData(r : Read, pi: NSProgressIndicator)
    {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            self.dict = self.read.flow(pi)
            dispatch_async(dispatch_get_main_queue(), {
                pi.stopAnimation(self)
                pi.hidden = true
                self.label.hidden = true
                self.stack.hidden = false
                self.nameField.becomeFirstResponder()
            })
        })
        success = false
    }
}
