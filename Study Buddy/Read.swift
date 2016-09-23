//
//  Read.swift
//  Study Siri
//
//  Created by Micah Zirn on 5/14/16.
//  Copyright © 2016 Micah Zirn. All rights reserved.
//

import Cocoa

class Read: AnyObject {
    var dict : [String : String] = [:]
    var activeDef : String = ""
    let attrString : NSAttributedString
    var mutable : NSAttributedString
    init(a : NSAttributedString)
    {
        attrString = a
        mutable = a
    }
    
    func boldString(n : Int) -> Int
    {
        var s = String()
        var m = n
        for i in n...(mutable.string.characters.count-1)
        {
            if !((mutable.attributesAtIndex(i, effectiveRange: NSRangePointer())["NSFont"]! as! NSFont).displayName!).containsString("Bold")
            {
                break
            }
            s.append(mutable.string[mutable.string.startIndex.advancedBy(i)])
            m = i
        }
        s = s.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if s.characters.count > 0
        {
            if (s.characters[s.endIndex.advancedBy(-1)] == "-" ||  s.characters[s.endIndex.advancedBy(-1)] == "\u{2013}") && !s.containsString("\n")
            {
                print(s)
                s = s.substringToIndex(s.characters.endIndex.advancedBy(-1))
                activeDef = s
            }
        }
        return m
    }
    func plainString(n : Int) -> Int
    {
        var s = String()
        var m = n
        for i in n...(mutable.string.characters.count-1)
        {
            if mutable.string.characters[mutable.string.startIndex.advancedBy(i)] == "\n"
            {
                break
            }
            s.append(mutable.string[mutable.string.startIndex.advancedBy(i)])
            m = i
        }
        dict[activeDef] = s
        activeDef = ""
        return m+1
    }
    func flow(pi: NSProgressIndicator) -> [String : String]
    {
        var i = 0
        while i < mutable.string.characters.count {
            if activeDef != ""
            {
                i = plainString(i) + 1
            }
            if ((mutable.attributesAtIndex(i, effectiveRange: NSRangePointer())["NSFont"]! as! NSFont).displayName!).containsString("Bold")
            {
                i = boldString(i)
            }
            pi.doubleValue+=1.0
            i++
        }
        return dict
    }
}
