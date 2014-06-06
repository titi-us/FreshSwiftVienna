//
//  AppDelegate.swift
//  FreshSwiftVienna
//
//  Created by Thibaut on 6/2/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet var window: NSWindow


    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        println("Start");
        
        var mainViewController = FTUIMainViewController();
        
        var frame = window.frame;
        frame.size.width = 1024;
        
        var currentHeight = frame.size.height;
        frame.size.height = 800;
        
        frame.origin.y -= (800 - currentHeight);
        window.setFrame(frame, display: true);
        window.contentView = mainViewController.view;
        window.setFrameAutosaveName(window.representedFilename);
        
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }


}

