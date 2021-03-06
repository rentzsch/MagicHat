#
# AppDelegate.rb
# MagicHat
#
# Created by wolf on 12/27/09.
# Copyright Red Shed Software Company 2009. All rights reserved.
#

class AppDelegate
  attr_writer :window
  attr_writer :webview
  
  def dumpFileWithPath(filePath)
    machoFile = MachOFileMO.insertInManagedObjectContext(managedObjectContext())

    error = Pointer.new_with_type('@')
    unless machoFile.parseFileURL(NSURL.fileURLWithPath(filePath), error:error)
        NSApp.presentError(error[0])
    end

    output = '';
    headers = machoFile.headers.allObjects.sortedArrayUsingDescriptors([NSSortDescriptor.sortDescriptorWithKey('offset', ascending:true)])
    headers.each do |header|
        output += "header: #{header.archName} offset:#{header.offset}\n"
        commands = header.commands.allObjects.sortedArrayUsingDescriptors([NSSortDescriptor.sortDescriptorWithKey('cmdoffset', ascending:true)])
        commands.each do |command|
            output += "\tcommand: #{command.name} offset:#{command.cmdoffset} cmdsize:#{command.cmdsize} (0x#{command.cmdsize.to_s(16)})\n"
            if command.kind_of?(MachOSegmentCommandMO)
                output += "\t\tsegment: #{command.segname} fileoff:#{command.fileoff} (0x#{command.fileoff.to_s(16)}) vmaddr:0x#{command.vmaddr} (0x#{command.vmaddr.to_s(16)}) filesize:#{command.filesize} (0x#{command.filesize.to_s(16)})\n"
                sections = command.sections.allObjects.sortedArrayUsingDescriptors([NSSortDescriptor.sortDescriptorWithKey('offset', ascending:true)])
                sections.each do |section|
                    output += "\t\t\tsection: #{section.sectname} offset:#{header.offset+section.offset} (#{section.offset}) size:#{section.size}\n"
                    if section.kind_of?(MachOClassesSectionMO)
                      output += "\t\t\t\tsectionData: #{section.sectionData.description}\n"
                    end
                end
            end
        end
    end
    puts output
  end
  
  def applicationDidFinishLaunching(notification)
    #puts @webview
    dumpFileWithPath('/Applications/Stickies.app/Contents/MacOS/Stickies')
    dumpFileWithPath('/Users/wolf/Tweetie 2.app/Tweetie 2')
    
    NSApp.terminate(nil)
  end

  # Creates and returns the managed object model for the application 
  # by merging all of the models found in the application bundle.
  def managedObjectModel
    if @managedObjectModel
      return @managedObjectModel
    end
    
    @managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
    return @managedObjectModel
  end


  # Returns the persistent store coordinator for the application.  This 
  # implementation will create and return a coordinator, having added the 
  # store for the application to it.  (The folder for the store is created, 
  # if necessary.)
  def persistentStoreCoordinator
    if @persistentStoreCoordinator
      return @persistentStoreCoordinator
    end

    error = Pointer.new_with_type('@')
    @persistentStoreCoordinator = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(self.managedObjectModel)
    unless @persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration:nil, URL:nil, options:nil, error:error)
      NSApp.presentError(error[0])
    end

    return @persistentStoreCoordinator
  end

  # Returns the managed object context for the application (which is already
  # bound to the persistent store coordinator for the application.) 
  def managedObjectContext
    return @managedObjectContext if @managedObjectContext
    
    coordinator = self.persistentStoreCoordinator
    if coordinator
      @managedObjectContext = NSManagedObjectContext.alloc.init
      @managedObjectContext.setPersistentStoreCoordinator(coordinator)
    end
    
    return @managedObjectContext
  end

  # Returns the NSUndoManager for the application.  In this case, the manager
  # returned is that of the managed object context for the application.
  def windowWillReturnUndoManager(window)
    return self.managedObjectContext.undoManager
  end

  # Performs the save action for the application, which is to send the save:
  # message to the application's managed object context.  Any encountered errors
  # are presented to the user.
  def saveAction(sender)
    error = Pointer.new_with_type('@')
    unless self.managedObjectContext.save(error)
      NSApp.presentError(error[0])
    end
  end

  # Implementation of the applicationShouldTerminate: method, used here to
  # handle the saving of changes in the application managed object context
  # before the application terminates.
  def applicationShouldTerminate(sender)
    error = Pointer.new_with_type('@')
    reply = NSTerminateNow
    
    if self.managedObjectContext
      if self.managedObjectContext.commitEditing
        if self.managedObjectContext.hasChanges and !self.managedObjectContext.save(error)
          # This error handling simply presents error information in a panel with an 
          # "Ok" button, which does not include any attempt at error recovery (meaning, 
          # attempting to fix the error.)  As a result, this implementation will 
          # present the information to the user and then follow up with a panel asking 
          # if the user wishes to "Quit Anyway", without saving the changes.

          # Typically, this process should be altered to include application-specific 
          # recovery steps.  

          errorResult = NSApp.presentError(error[0])
          
          if errorResult
            reply = NSTerminateCancel
          else
            alertReturn = NSRunAlertPanel(nil, "Could not save changes while quitting. Quit anyway?" , "Quit anyway", "Cancel", nil)
            if alertReturn == NSAlertAlternateReturn
              reply = NSTerminateCancel
            end
          end
        end
      else
        reply = NSTerminateCancel
      end
    end
    
    return reply
  end

end
