//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lakshmi Vineeth on 4/12/15.
//  Copyright (c) 2015 Amstel Coder. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    
    var audioPlayer = AVAudioPlayer()
    var echoAudioPlayer = AVAudioPlayer()
    var recievedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Load audio file 'receivedAudio' to audioPlayer & audioEngine
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        echoAudioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(2.0)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithReverb()
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithEcho()
    }
    
    
    @IBAction func stopAudioPlayback(sender: UIButton) {
        stopAudio()
    }
    

    //  Function to play Audio with Variable Rate
    func playAudioWithVariableRate(rate: Float){
        stopAudio()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    //  Function to play Audio with Variable Pitch
    func playAudioWithVariablePitch(pitch: Float){
        stopAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    
    // Function to play Audio with Reverb
    func playAudioWithReverb(){
        stopAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.MediumHall)
        reverbEffect.wetDryMix = 50
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    
    // Function to play Audio with Echo
    func playAudioWithEcho(){
        stopAudio()
        
        //playback audio as is
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 1.0
        audioPlayer.play()
        
        //playback delayed audio with lower volume
        echoAudioPlayer.currentTime = 0.0
        echoAudioPlayer.volume = 0.8
        echoAudioPlayer.playAtTime(echoAudioPlayer.deviceCurrentTime + 0.2)
    }
    
    
    //  Function to stop & reset all audio players and audio engine
    func stopAudio(){
        audioPlayer.stop()
        echoAudioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
