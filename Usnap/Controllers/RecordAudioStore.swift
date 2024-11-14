//
//  RecordAudioStore.swift
//  Toca
//
//  Created by Ramanpreet Singh on 23/02/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

// MARK: Custom delegate

protocol delegate {
    func recordingTime(_ time: String!)
    func popDelegate()
}


class RecordAudioStore: NSObject {
    var recorder: AVAudioRecorder!
    var meterTimer:Timer!
    var soundFileURL:URL!
    var recordingDelegate: delegate!
    var currentFile: String!
    var myCompletion: ((_ : NSURL?, _: String?) -> Void)? = nil
    var isStartRecording: Bool = false
    
    class var shared: RecordAudioStore {
        struct Static {
            static let instance: RecordAudioStore = RecordAudioStore()
        }
        return Static.instance
    }
    
    // MARK: Update Audio Meter
    @objc func updateAudioMeter(_ timer:Timer) {
        if recorder != nil {
            if recorder.isRecording {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let string = String(format: "%02d:%02d", min, sec)
                recordingDelegate.recordingTime(string)
                recorder.updateMeters()
            }
        }
    }
    
    // MARK: Record Audio
    func recordAudioWithURL(_ sender: UIButton, completion: @escaping ( _: NSURL?, _: String?) -> Void) {
        myCompletion = completion
        switch sender.tag {
        case 0: //Start Recording
            stratAudioRecording()
            break
        case 1: //Stop Recording
            stopAudioRecording()
            break
        default:
            break
        }
    }
    
    //MARK: Start Audio Recording
    func stratAudioRecording() {
        isStartRecording = true
        if recorder == nil {
            recordWithPermission(true)
            return
        }
    }
    
    //MARK: Stop Audio Recording
    func stopAudioRecording() {
        isStartRecording = false
        recorder?.stop()
        if meterTimer != nil {
            meterTimer.invalidate()
        }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: set Up Recorder
    func setupRecorder() {
        let fileName = "file.m4a"
//        let fileName = String(format: "%@%@%@", "Toca-", ((NSDate.new() as NSDate).string(withFormat: "yyyy-MM-dd-HH-mm-ss")),".m4a")
        currentFile = fileName
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(fileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        let recordSettings: [String: AnyObject] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: NSNumber(value:1),
            AVSampleRateKey: NSNumber(value:8000.0)]
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.record(forDuration: 180.00) // record for 3 minutes
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
    }
    
    // MARK: Get Directory Path
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // MARK: get Audio FileURL
    func getAudioFileURL(_ file: String!, completion: @escaping (_ : NSURL?) -> Void) {
        let fileManager = FileManager.default
        let audiofilePath = (self.getDirectoryPath() as NSString).appendingPathComponent(file)
        if fileManager.fileExists(atPath: audiofilePath) {
            let audioUrl = NSURL(fileURLWithPath: audiofilePath)
            completion(audioUrl)
        } else {
            completion(nil)
        }
    }
    
    var isPermission: Bool {
        var isValid: Bool = false
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            isValid = granted
        })
        return isValid
    }
    
    var session: AVAudioSession {
        return AVAudioSession.sharedInstance()
    }
    
    // MARK: Record Permission
    func recordWithPermission(_ setup: Bool) {
        // ios 8 and later
        if isPermission {
            self.setSessionPlayAndRecord()
            if setup {
                self.setupRecorder()
            }
            self.recorder.record()
            self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(RecordAudioStore.updateAudioMeter(_:)), userInfo:nil, repeats:true)
        }
    }
    
    // MARK: Play And Record
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
}

// MARK: AVAudioRecorderDelegate

extension RecordAudioStore : AVAudioRecorderDelegate {
    
    // MARK: DidFinishRecording Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        if flag {
            showAlert()
        } else {
            SVProgressHUD.showError(withStatus: "Some error has been occurred.")
        }
    }
    
    //MARK: Show Alert
    func showAlert() {
        let alert = UIAlertController(title: "Confirm!",
                                      message: "Finished recording.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {action in
            self.getAudioFileURL(self.currentFile) { (url) in
                self.myCompletion!(url!, self.currentFile)
                self.recorder = nil
                self.recordingDelegate.popDelegate()
            }
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.recorder.deleteRecording()
            self.myCompletion!(nil, nil)
            self.recordingDelegate.recordingTime("00:00")
            self.recorder = nil
            UIApplication.visibleNavigationController.popViewController(animated: true)
        }))
        
        UIApplication.visibleViewController.present(alert, animated:true, completion:nil)
    }
    
    // MARK: Recorder EncodeError Delegate
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}


