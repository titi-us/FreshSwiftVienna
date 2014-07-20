//
//  PersistentStack.swift
//  FreshVienna
//
//  Created by Thibaut on 7/10/14.
//  Copyright (c) 2014 Thibaut. All rights reserved.
//

import Foundation
import CoreData

class PersistentStack
{
    var managedObjectContext:NSManagedObjectContext;
    let modelURL:NSURL;
    let storeURL:NSURL;
    
    
    init(storeURL sURL:NSURL, modelURL mURL:NSURL)
    {
        storeURL = sURL;
        modelURL = mURL;
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType);
        setupManagedObjectContext();
    }
    
    func setupManagedObjectContext()
    {
        managedObjectContext.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel(contentsOfURL:modelURL));
        
        
        var error:NSError?;
        managedObjectContext.persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error);
        
        if (error != nil)
        {
            println("something bad happened");
        }
        
        managedObjectContext.undoManager = NSUndoManager();
    }
    
    
}