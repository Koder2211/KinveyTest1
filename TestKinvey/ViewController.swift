//
//  ViewController.swift
//  TestKinvey
//
//  Created by Santosh Surve on 3/30/16.
//  Copyright © 2016 mindscrub. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
     var jobRoles:[AnyObject] = []
    var uploadID:String = ""
   
 
    @IBOutlet weak var imgView2: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.tblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
//        if KCSUser.activeUser() == nil {
//            KCSUser.createAutogeneratedUser(
//                [
//                    KCSUserAttributeEmail : "pranav@kinvey.com",
//                    KCSUserAttributeGivenname : "Pranav",
//                    KCSUserAttributeSurname : "Kinvey"
//                ],
//                completion: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
//                    //do something
//                    
//                    let collection = KCSCollection(fromString: "Job-Roles", ofClass: JobRole.self)
//                    let store = KCSAppdataStore(collection: collection, options: nil)
//                    
//                    store.queryWithQuery(
//                        KCSQuery(),
//                        withCompletionBlock: {
//                            (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
//                            if errorOrNil == nil {
//                                NSLog("successfully loaded objects: %@", objectsOrNil)
//                                self.jobRoles = objectsOrNil
//                                self.tblView .reloadData()
//                                for var i = 0; i < self.jobRoles.count ; ++i {
//                                    let name = self.jobRoles[i].name
//                                    NSLog("Job-Role is : %@", name!)
//                                    
//                                }
//                            } else {
//                                NSLog("error occurred: %@", errorOrNil)
//                            }
//                        },
//                        withProgressBlock: nil
//                    )
//                    
//                }
//            )
//        } else {
//            //otherwise user is set and do something
//            NSLog("user: %@", KCSUser.activeUser().username)
//            
//            let collection = KCSCollection(fromString: "Job-Roles", ofClass: JobRole.self)
//            let store = KCSAppdataStore(collection: collection, options: nil)
//            
//            store.queryWithQuery(
//                KCSQuery(),
//                withCompletionBlock: {
//                    (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
//                    if errorOrNil == nil {
//                        NSLog("successfully loaded objects: %@", objectsOrNil)
//                        self.jobRoles = objectsOrNil
//                        self.tblView .reloadData()
//                        for var i = 0; i < self.jobRoles.count ; ++i {
//                            let name = self.jobRoles[i].name
//                            NSLog("Job-Role is : %@", name!)
//                            
//                        }
//                    } else {
//                        NSLog("error occurred: %@", errorOrNil)
//                    }
//                },
//                withProgressBlock: nil
//            )
//        }

        
        KCSUser.loginWithUsername(
            "test123",
            password: "test123",
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    //the log-in was successful and the user is now the active user and credentials saved
                    //hide log-in view and show main app content
                    KCSUser.activeUser()
                    
                    
                    self.updateImage()
                    //self.updatePersonalProfileToKinvey()
                    //self.downloadImage()
                    
                    let collection = KCSCollection(fromString: "Job-Roles", ofClass: JobRole.self)
                    let store = KCSAppdataStore(collection: collection, options: nil)
                    
                    let store1 = KCSAppdataStore.storeWithOptions([
                        KCSStoreKeyCollectionName : "Job-Roles",
                        KCSStoreKeyCollectionTemplateClass : JobRole.self
                        ])
                    
                    let jobRole1 = JobRole()
                    jobRole1.name = "MyJobSantosh4"
                    jobRole1.date = NSDate(timeIntervalSince1970: 1352149171)
                    
                    store1.saveObject(
                        jobRole1,
                        withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                            if errorOrNil != nil {
                                //save failed
                                NSLog("Save failed, with error: %@", errorOrNil.localizedFailureReason!)
                            } else {
                                //save was successful
                                NSLog("Successfully saved event (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                            }
                        },
                        withProgressBlock: nil
                    )

                    
                    
                    store.queryWithQuery(
                        KCSQuery(),
                        withCompletionBlock: {
                            (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                            if errorOrNil == nil {
                                NSLog("successfully loaded objects: %@", objectsOrNil)
                                self.jobRoles = objectsOrNil
                                self.tblView .reloadData()
                                for var i = 0; i < self.jobRoles.count ; ++i {
                                    let jobrl = self.jobRoles[i]
                                    
                                    NSLog("Job-Role is : %@", jobrl.name)
                                    
                                }
                            } else {
                                NSLog("error occurred: %@", errorOrNil)
                            }
                        },
                        withProgressBlock: nil
                    )
                    

                    
                } 
            }
        )
        
        
    }
    
    func downloadImage()
    {
        let attrib = "texture1.png"
        
        let pngQuery = KCSQuery(onField: KCSFileFileName, withExactMatchForValue: attrib as! NSObject)
        
        
        
        
        
        KCSFileStore.downloadFileByQuery(pngQuery,
                                         requestConfiguration: nil,
                                         completionBlock: { (downloadedResources: [AnyObject]!, error: NSError!) -> Void in
                                            if error == nil {
                                                
                                                
                                                //extract just the Value field from the entities
                                                
                                                
                                                let file = downloadedResources[0] as! KCSFile
                                                
                                                let fileURL = file.localURL
                                                let image = UIImage(contentsOfFile: fileURL.path!)
                                                
                                                self.imgView2.image = image
                                                print(file.localURL)
                                                
                                            } else {
                                                print("Got an error: ", error)
                                            }
            },
                                         progressBlock: nil
        )
        
        
    }
    
    func updateImage()
    {
        //let image = UIImage(named: "example.png")
        let data = UIImageJPEGRepresentation(UIImage(named: "reminder152.png")!,0.9) //convert to a 90% quality jpeg
        
        
        KCSFileStore.uploadData(data,
                                options: [
                                    KCSFileFileName : "texture1.png",
                                    KCSFileMimeType : "image/png",
                                    
                                    
            ],
                                completionBlock: { (uploadInfo: KCSFile!, error: NSError!) -> Void in
                                    
                                    
                                    //self.assignProfilePictureIdToUser(KCSUser.activeUser(), picture: uploadInfo)
                                    self.uploadID = uploadInfo.kinveyObjectId()
                                    //KCSUser.activeUser().setValue(uploadInfo.kinveyObjectId(), forAttribute: "usename")
                                    
                                    
                                    self.downloadImage()
                                    
                                    
                                    
            },
                                progressBlock: { (objects: [AnyObject]!, percentComplete: Double) -> Void in
            }
        )
    }
    
    func queryUser()
    {
        let user1: KCSUser
        user1 = KCSUser.activeUser()
        
        let query: KCSQuery
        //query.addQueryOnField("username", withExactMatchForValue: "test123")
        
    }
    
    func updatePersonalProfileToKinvey()
    {
        let user1: KCSUser
        user1 = KCSUser.activeUser()
    // update user skipper info
    
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]];
//    NSError *error = nil;
//    
//    NSArray *profiles = [[self.cdt backgroundManagedObjectContext] executeFetchRequest:request error:&error];
//    if ([profiles count] == 1) {
//    Profile *userProfile = [profiles lastObject];
//    //NSLog(@"user: %@", [userProfile description]);
//    
//    if ([[userProfile valueForKey:@"ytdDMG"] floatValue] >=0) {
//    [user setValue:[userProfile valueForKey:@"ytdDMG"] forAttribute:@"ytdDMG"];
//    } else [user setValue:[NSNumber numberWithInt:0] forAttribute:@"ytdDMG"];
//    
//    if ([[userProfile valueForKey:@"ytdTrips"] intValue] >=0) {
//    [user setValue:[userProfile valueForKey:@"ytdTrips"] forAttribute:@"ytdTrips"];
//    } else [user setValue:[NSNumber numberWithInt:0] forAttribute:@"ytdTrips"];
//    
//    if ([[userProfile valueForKey:@"ytdSailingTime"] floatValue] >=0) {
//    [user setValue:[userProfile valueForKey:@"ytdSailingTime"] forAttribute:@"ytdSailingTime"];
//    }  else [user setValue:[NSNumber numberWithInt:0] forAttribute:@"ytdSailingTime"];
//    
//    if ([[userProfile valueForKey:@"overallDMG"] floatValue] >=0) {
//    [user setValue:[userProfile valueForKey:@"overallDMG"] forAttribute:@"overallDMG"];
//    } else [user setValue:[NSNumber numberWithInt:0] forAttribute:@"overallDMG"];
//    
//    if ([[userProfile valueForKey:@"overallTrips"] intValue] >=0) {
//    [user setValue:[userProfile valueForKey:@"overallTrips"] forAttribute:@"overallTrips"];
//    } else [user setValue:[NSNumber numberWithInt:0] forAttribute:@"overallTrips"];
//    
//    if ([[userProfile valueForKey:@"overallSailingTime"] floatValue] >=0) {
//    [user setValue:[userProfile valueForKey:@"overallSailingTime"] forAttribute:@"overallSailingTime"];
//    } else [user setValue:[NSNumber numberWithInt:0] forAttribute:@"overallSailingTime"];
//    
//    [user saveWithCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//    NSLog(@"saved user: %@ - %@", @(errorOrNil == nil), errorOrNil);
//    [[NSNotificationCenter defaultCenter] postNotificationName:KINVEY_SYNC_DONE object:self];
//    
//    }];
//    }
        
        
        user1.saveWithCompletionBlock {
            (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
            if errorOrNil == nil {
                NSLog("successfully saved user object: %@", objectsOrNil)
                
            } else {
                NSLog("error occurred: %@", errorOrNil)
            }
        }
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobRoles.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tblView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        let jobrl2 = self.jobRoles[indexPath.row]
        cell.textLabel?.text = jobrl2.name
        
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

