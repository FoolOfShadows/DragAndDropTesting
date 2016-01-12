//
//  DragAndDropZone.swift
//  PTVN to PF
//
//  Created by Fool on 12/16/15.
//  Copyright © 2015 Fulgent Wake. All rights reserved.
//

import Cocoa

class DragAndDropZone: NSView {
	
	//The variables we want to make available
	var dndFileName = String()
	var dndSwitch = 1
	

	//Set the file types we're looking to process
	let fileTypes = ["txt", "md"]
	//Create a boolean to hold the check for the file type
	var fileTypeIsOK = false
	
	var droppedFilePath: String = ""
	
	//Need this to avoid error of not calling the required intitializer for the frame
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		commonInit()
	}
	
	//Define the appearance of the drop area
	override func drawRect(dirtyRect: NSRect) {
		var bPath:NSBezierPath = NSBezierPath(rect: dirtyRect)
		let fillColor = NSColor.lightGrayColor()
		fillColor.set()
		bPath.fill()
		
		let borderColor = NSColor.lightGrayColor()
		borderColor.set()
		bPath.lineWidth = 1.0
		bPath.stroke()
		
		//super.drawRect(dirtyRect)
    }
	
	//Not sure what exactly this is
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
		//registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType])
	}
	
	//Set up the initialization parameters for the types of objects which can be dropped
	func commonInit() {
		self.registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType])
	}
	
	//When the object connected to this class receives a drag, check to see if the files
	//extension matches the extensions we want to handle
	override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
		if checkExtension(sender) == true {
		//If the extension type is one we want to handle, make a copy of the information
		self.fileTypeIsOK = true
		return .Copy
		} else {
			//If the exteinsion is NOT one we want to handle, do nothing
			self.fileTypeIsOK = false
			return .None
		}
	}

	//I'm not sure I need this override
//	override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
//		return true
//	}
	
	override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
		if self.fileTypeIsOK {
			return .Copy
		} else {
			return .None
		}
	}
	

	//Respond to the drop
	override func performDragOperation(sender: NSDraggingInfo?) -> Bool {
		let board = sender!.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray
		//Make sure the pasteboard is not empty
		if board != [] {
			//We can only process one object, so grab the first item in the array
			droppedFilePath = board![0] as! String
			dndFileName = board![0] as! String
			Swift.print(dndFileName)
			//Let whatever code is watching know that a new file has been selected
			dndSwitch = 0
			return true
		}
		return false
	}
	
	//Not sure what this is doing
	func checkExtension(drag: NSDraggingInfo) -> Bool {
		if let board = drag.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
			let path = board[0] as? String {
				let url = NSURL(fileURLWithPath: path)
				if let suffix = url.pathExtension {
					for ext in self.fileTypes {
						if ext.lowercaseString == suffix {
							return true
						}
					}
				}
		}
		return false
	}
	
}
