//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lakshmi Vineeth on 4/11/15.
//  Copyright (c) 2015 Amstel Coder. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //  Outlet to access UI elements
    @IBOutlet weak var lblRecordingProgress: UILabel!
    @IBOutlet weak var btnStopRecording: UIButton!
    @IBOutlet weak var btnPauseRecording: UIButton!
    @IBOutlet weak var btnResumeRecording: UIButton!

    
    //  Create objects for AVAudioRecorder
    var audioRecorder: AVAudioRecorder!
    
    
    //  Create model class RecordedAudio Object
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //  Set\Reset UI Elements to allow recording
    override func viewWillAppear(animated: Bool) {
        btnStopRecording.hidden = true
        btnPauseRecording.hidden = true
        btnResumeRecording.hidden = true
        lblRecordingProgress.text = "Tap to Record"
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //  Action to Record Audio
    @IBAction func recordAudio(sender: UIButton) {
        
        //  Show\ Modify UI elements
        lblRecordingProgress.text = "Recording in Progress"
        btnPauseRecording.hidden = false
        btnStopRecording.hidden = false
        
        //  Create filePath for recording using current date time
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //  Start recording
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    //  Action to Stop Recording
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
    //  Action to Pause Recording
    @IBAction func pauseRecording(sender: UIButton) {
        btnResumeRecording.hidden = false
        btnPauseRecording.hidden = true
        audioRecorder.pause()
    }
    
    
    //  Action to Resume Recording
    @IBAction func resumeRecording(sender: UIButton) {
        btnResumeRecording.hidden = true
        btnPauseRecording.hidden = false
        audioRecorder.record()
    }
    
    
    //  Delegate called when a recording is stopped
    //  @flag - true if successful
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag)
        {
            
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            
            //  Reset UI to enable recording again
            lblRecordingProgress.text = "Tap to Record"
            btnStopRecording.hidden = true
            btnPauseRecording.hidden = true
            btnResumeRecording.hidden = true
            
            //  Display alert message
            let alertController = UIAlertController(title: "Pitch Perfect", message: "Recording not successful", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    //  Set destinationViewController and pass Recorded Audio 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
}

