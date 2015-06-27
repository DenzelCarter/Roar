//
//  ViewController.swift
//  Roar
//
//  Created by Denzel Carter on 6/24/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class NoteTakerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()
    var notesArray: [Note] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func addNew(sender: AnyObject) {
        self.performSegueWithIdentifier("addNewRecording", sender: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext! //1
        var request = NSFetchRequest(entityName: "Note")
        self.notesArray = context.executeFetchRequest(request, error: nil)! as! [Note]
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var sound = notesArray[indexPath.row]
        var cell = UITableViewCell()
        cell.textLabel!.text = sound.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sound = notesArray[indexPath.row]
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        var pathComponets = [baseString, sound.url]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponets)!
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        self.audioPlayer = AVAudioPlayer(contentsOfURL: audioNSURL, error: nil)
        self.audioPlayer.play()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
              let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
              let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
              let context: NSManagedObjectContext = appDel.managedObjectContext!
              context.deleteObject(notesArray[indexPath.row] as NSManagedObject)
              notesArray.removeAtIndex(indexPath.row)
              context.save(nil)
              self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
          return
        }
    }
    


}

