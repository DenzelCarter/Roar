//
//  NewNoteViewController.swift
//  Roar
//
//  Created by Denzel Carter on 6/25/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData


class NewNoteViewController: UIViewController {
    @IBOutlet var noteTextField: UITextField!
    @IBOutlet var recordOutlet: UIButton!
    
    var audioRecorder: AVAudioRecorder
    var audioURL: String
    
    required init(coder aDecoder: NSCoder) {
        
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        self.audioURL = NSUUID().UUIDString + ".m4a"
        var pathComponents = [baseString, self.audioURL]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)!
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = AVAudioRecorder(URL: audioNSURL, settings: recordSettings, error: nil)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        
        super.init(coder: aDecoder)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func cancel_click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func save_click(sender: AnyObject) {
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        var note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: context) as! Note
        note.name = noteTextField.text
        note.url = audioURL
        context.save(nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func record_click(sender: AnyObject) {
        
        if audioRecorder.recording {
            audioRecorder.stop()
        }else{
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            audioRecorder.record()
            
        }
        
    }
    
    
    
    
    
    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
