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
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var progressView2: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressLabel2: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    
    
    var audioRecorder: AVAudioRecorder
    var audioURL: String
    let timeInterval:NSTimeInterval = 0.5
    
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
        recordOutlet.layer.shadowOpacity = 1.0
        recordOutlet.layer.shadowOffset = CGSize(width: 5.0, height: 4.0)
        recordOutlet.layer.shadowRadius = 5.0
        recordOutlet.layer.shadowColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func cancel_click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func save_click(sender: AnyObject) {
        if noteTextField.text != "" {
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        var note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: context) as! Note
        note.name = noteTextField.text
        note.url = audioURL
        context.save(nil)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func record_click(sender: AnyObject) {
        var mic = UIImage(named: "microphoneDepressed.png") as UIImage!
        recordOutlet.setImage(mic, forState: .Normal)
        recordOutlet.layer.shadowOpacity = 0.9
        recordOutlet.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        recordOutlet.layer.shadowRadius = 5.0
        recordOutlet.layer.shadowColor = UIColor.blackColor().CGColor
        
        if audioRecorder.recording {
            audioRecorder.stop()
        }else{
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            audioRecorder.record()
        }
    }
    
    
    @IBAction func touchDownRecord(sender: AnyObject) {
        var timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self,
            selector: "updateAudioMeter:",
            userInfo: nil,
            repeats: true)
        
        recordOutlet.layer.shadowOpacity = 0.9
        recordOutlet.layer.shadowOffset = CGSize(width: -2.0, height: -2.0)
        recordOutlet.layer.shadowRadius = 1.0
        recordOutlet.layer.shadowColor = UIColor.blackColor().CGColor

    }
    
    
    
    func updateAudioMeter(timer: NSTimer){
        if audioRecorder.recording {
            
            let dFormat = "%02d"
            let min:Int = Int(audioRecorder.currentTime / 60)
            let sec:Int = Int(audioRecorder.currentTime % 60)
            let timeString = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            timeLabel.text = timeString
            audioRecorder.updateMeters()
            var averageAudio = audioRecorder.averagePowerForChannel(0) * -1
            var peakAudio = audioRecorder.peakPowerForChannel(0) * -1
            var progressView1Average = Int(averageAudio)    //   / 100.0  divide if using a float
            var progressView2Peak = Int(peakAudio) //   / 100.0  divide if using a float
            progressLabel.text = ("\(progressView1Average)%")
            progressLabel2.text = ("\(progressView2Peak)%")
            
            bar(progressView1Average, progressBar2: progressView2Peak)
            
        }else if !audioRecorder.recording {
            var mic = UIImage(named: "microphone.png") as UIImage!
            recordOutlet.setImage(mic, forState: .Normal)
            progressView.setProgress(0, animated: true)
            progressView2.setProgress(0, animated: true)
            progressLabel.text = "0%"
            progressLabel2.text = "0%"
        }
    }
    
    
    func bar(progressBar1: Int, progressBar2: Int)
    {
        switch progressBar1 {
        case 0...2:
            progressView.setProgress(1.00, animated: true)
        case 0...2:
            progressView.setProgress(1.00, animated: true)
        case 3...5:
            progressView.setProgress(0.80, animated: true)
        case 6...8:
            progressView.setProgress(0.74, animated: true)
        case 9...11:
            progressView.setProgress(0.70, animated: true)
        case 13...15:
            progressView.setProgress(0.65, animated: true) //normal speak start
        case 16...18:
            progressView.setProgress(0.64, animated: true)
        case 19...21:
            progressView.setProgress(0.63, animated: true)
        case 22...24:
            progressView.setProgress(0.62, animated: true) //normal speak end
        case 25...27:
            progressView.setProgress(0.60, animated: true)
        case 29...31:
            progressView.setProgress(0.55, animated: true)
        case 32...34:
            progressView.setProgress(0.51, animated: true)
        case 35...37:
            progressView.setProgress(0.48, animated: true)
        case 38...40:
            progressView.setProgress(0.45, animated: true)
        case 41...43:
            progressView.setProgress(0.42, animated: true)
        case 44...46:
            progressView.setProgress(0.39, animated: true)
        case 47...49:
            progressView.setProgress(0.36, animated: true)
        case 50...52:
            progressView.setProgress(0.33, animated: true)
        case 53...55:
            progressView.setProgress(0.25, animated: true)
        case 56...60:
            progressView.setProgress(0.24, animated: true) //no talking range start
        case 61...63:
            progressView.setProgress(0.23, animated: true)
        case 64...66:
            progressView.setProgress(0.22, animated: true)
        case 67...69:
            progressView.setProgress(0.21, animated: true)
        case 71...73:
            progressView.setProgress(0.20, animated: true)
        case 75...77:
            progressView.setProgress(0.18, animated: true)
        case 79...81:
            progressView.setProgress(0.17, animated: true)
        case 82...84:
            progressView.setProgress(0.15, animated: true)
        case 85...87:
            progressView.setProgress(0.13, animated: true)
        case 89...91:
            progressView.setProgress(0.10, animated: true)
        case 93...95:
            progressView.setProgress(0.05, animated: true)
        case 96...98:
            progressView.setProgress(0.03, animated: true) //no talking range end
        case 99...100:
            progressView.setProgress(0.00, animated: true)
        default:
            progressView.setProgress(0.20, animated: true)
        }
        switch progressBar2 {
        case 0...2:
            progressView2.setProgress(1.00, animated: true)
        case 3...5:
            progressView2.setProgress(0.80, animated: true)
        case 6...8:
            progressView2.setProgress(0.74, animated: true)
        case 9...11:
            progressView2.setProgress(0.70, animated: true)
        case 13...15:
            progressView2.setProgress(0.65, animated: true) //normal speak start
        case 16...18:
            progressView2.setProgress(0.64, animated: true)
        case 19...21:
            progressView2.setProgress(0.63, animated: true)
        case 22...24:
            progressView2.setProgress(0.62, animated: true) //normal speak end
        case 25...27:
            progressView2.setProgress(0.60, animated: true)
        case 29...31:
            progressView2.setProgress(0.55, animated: true)
        case 32...34:
            progressView2.setProgress(0.51, animated: true)
        case 35...37:
            progressView2.setProgress(0.48, animated: true)
        case 38...40:
            progressView2.setProgress(0.45, animated: true)
        case 41...43:
            progressView2.setProgress(0.42, animated: true)
        case 44...46:
            progressView2.setProgress(0.39, animated: true)
        case 47...49:
            progressView2.setProgress(0.36, animated: true)
        case 50...52:
            progressView2.setProgress(0.33, animated: true)
        case 53...55:
            progressView2.setProgress(0.25, animated: true)
        case 56...60:
            progressView2.setProgress(0.24, animated: true) //no talking range start
        case 61...63:
            progressView2.setProgress(0.23, animated: true)
        case 64...66:
            progressView2.setProgress(0.22, animated: true)
        case 67...69:
            progressView2.setProgress(0.21, animated: true)
        case 71...73:
            progressView2.setProgress(0.20, animated: true)
        case 75...77:
            progressView2.setProgress(0.18, animated: true)
        case 79...81:
            progressView2.setProgress(0.17, animated: true)
        case 82...84:
            progressView2.setProgress(0.15, animated: true)
        case 85...87:
            progressView2.setProgress(0.13, animated: true)
        case 89...91:
            progressView2.setProgress(0.10, animated: true)
        case 93...95:
            progressView2.setProgress(0.05, animated: true)
        case 96...98:
            progressView2.setProgress(0.03, animated: true) //no talking range end
        case 99...100:
            progressView2.setProgress(0.00, animated: true)
        default:
            progressView2.setProgress(0.20, animated: true)
        }
        return
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
