//
//  ViewController.swift
//  bellend
//
//  Created by Alasdair on 16/11/2014.
//
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    let captureSession = AVCaptureSession();
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        let devices = AVCaptureDevice.devices();

        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == AVCaptureDevicePosition.Back {
                    captureDevice = device as? AVCaptureDevice;
                }
            }
        }
        
        if captureDevice != nil {
            beginSession();
        }
        
        initBeep();
    }
    
    func beginSession() {
        
        var err : NSError? = nil;
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err));
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewView.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
    }
    
    var beepPlayer : AVAudioPlayer?
    
    var beepSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep1", ofType: "aiff")!)
    func initBeep(){
        beepPlayer = AVAudioPlayer(contentsOfURL: beepSound, error: nil)
        
        if let player = beepPlayer {
            player.prepareToPlay()
        }
    }
    
    func playBeepSound(){
        if let player = beepPlayer {
            player.play()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        super.touchesBegan(touches, withEvent: event)
        playBeepSound()
    }
    
    @IBAction func btnPlayBeepSound(sender: AnyObject) {
        
    }
    
    var recording : Bool = false;
    @IBAction func action(sender: AnyObject) {
        
        recording = !recording
        
        let greenImage = UIImage(named: "green")
        let redImage = UIImage(named: "red")
        
        if recording {
        
            self.recordButton.setImage(redImage, forState: UIControlState.Normal)
        }  else {
            
            self.recordButton.setImage(greenImage, forState: UIControlState.Normal)
        }
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

