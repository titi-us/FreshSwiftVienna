//
//  AppDelegate.swift
//  FreshSwiftVienna
//
//  Created by Thibaut on 6/2/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet var window: NSWindow?
    var persistentStack:PersistentStack?;

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        println("Start");
        
        let documentDirectory:NSURL = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil);
        
        let storeURL = documentDirectory.URLByAppendingPathComponent("db.sqlite");
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd");
        
        persistentStack = PersistentStack(storeURL: storeURL, modelURL: modelURL)
        
        
        var mainViewController = FTUIMainViewController(nibName:nil, bundle:nil);
        window!.contentView = mainViewController.view;
        window!.representedFilename = "MainWindow";
        
      
        if let control : NSWindowController = window!.windowController() as? NSWindowController
        {
            control.shouldCascadeWindows = false;
        }
                
        window!.setFrameAutosaveName(window!.representedFilename);
        
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }


}

