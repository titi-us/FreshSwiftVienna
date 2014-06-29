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
        
        var mainViewController = FTUIMainViewController(nibName:nil, bundle:nil);
        // TODO, do that if the size is default;
//        var frame = window.frame;
//        frame.size.width = 1400;
        
//        var currentHeight = frame.size.height;
//        frame.size.height = 800;
        
//        frame.origin.y -= (800 - currentHeight);
//        window.setFrame(frame, display: true);
        window.contentView = mainViewController.view;
        window.representedFilename = "MainWindow";
        
      
        if let control : NSWindowController = window.windowController() as? NSWindowController
        {
            control.shouldCascadeWindows = false;
        }
                
        window.setFrameAutosaveName(window.representedFilename);
        
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }


}

