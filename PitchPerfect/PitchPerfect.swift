//
//  PitchPerfect.swift
//  PitchPerfect
//
//  Created by Ali Alawami on 02/09/2019.
//  Copyright © 2019 Ali Alawami. All rights reserved.
//

import UIKit
import AVFoundation

class PitchPerfect: UIViewController, AVAudioRecorderDelegate {
    
    
    //MARK: properties
     var audioRecorder: AVAudioRecorder!
    let session = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.3803921569, blue: 0.5529411765, alpha: 1)
        self.setupSubViews()
        self.navigationController?.navigationBar.isHidden = true
        self.setNeedsStatusBarAppearanceUpdate()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
   
    
    //MARK: UI Items
    
    lazy var startRecording:UIButton = {
        let button = UIButton()
        
        
        //Normal
        
        button.setImage(#imageLiteral(resourceName: "Record"), for: UIControl.State.normal)
        //Selected
        button.setImage(#imageLiteral(resourceName: "Stop"), for: UIControl.State.selected)
        
        
        //Add action
        button.addTarget(self, action: #selector(recordingFunctions), for: UIControl.Event.touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    lazy var infoLabel:UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = Recording.start.infomation.uppercased()
        label.autoresizesSubviews = true
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    
    
    
    func setupSubViews(){
        startRecording.isSelected = false
        //Adding view to superView
        self.view.addSubview(startRecording)
        self.view.addSubview(infoLabel)
        
        
        //Setup Constraint to the center
        let margins = self.view.safeAreaLayoutGuide
        self.startRecording.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        self.startRecording.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        
        
        //Setup Constraint for the information label
        self.startRecording.topAnchor.constraint(equalToSystemSpacingBelow: infoLabel.bottomAnchor, multiplier: 4).isActive = true
        self.infoLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
    }
    
    
    @objc func recordingFunctions(){
 
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.startRecording.transform = CGAffineTransform(scaleX: -0.5, y: -0.5)
            UIView.transition(with: self.startRecording, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                if self.startRecording.isSelected{
                    self.startRecording.isSelected = false
                    self.infoLabel.text = Recording.start.infomation.uppercased()
                    self.audioRecordingStopped()
                }
                else{
                    self.startRecording.isSelected = true
                    self.infoLabel.text = Recording.stop.infomation.uppercased()
                    
                    self.audioRecording()
                    
                }
            }, completion: nil)
            
            
            
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.startRecording.transform = CGAffineTransform.identity
            }, completion: nil)
            
        
        
        }
        
        
        
        
    }
    
 
    
    
    func audioRecording(){
        self.progressIndicator()
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        
        guard let filePath = URL(string: pathArray.joined(separator: "/")) else {return }
        
        
        let settings:[String:Any] = [:]
        
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: settings)
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
      
        
        
    }
    
    func audioRecordingStopped (){
        audioRecorder.stop()
        try! session.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag{
            let vc = PlaySoundsViewController()
            vc.recordedAudioURL = audioRecorder.url
            self.modalPresentationStyle = .custom
            self.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true){
                self.circleShape.removeFromSuperlayer()
            }
        }else{
            let alert = UIAlertController()
            alert.message = "error"
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    let circleShape = CAShapeLayer()
    
    func progressIndicator(){
        
        circleShape.fillColor = nil
        circleShape.lineCap = .round
        circleShape.lineWidth = 4
        circleShape.strokeColor = #colorLiteral(red: 0.03342677653, green: 0.605599463, blue: 0.551651299, alpha: 0.6279430651)
        let viewFrame = self.startRecording.layoutMarginsGuide.layoutFrame
        let center = CGPoint(x: viewFrame.width/2, y: viewFrame.width/2)
        circleShape.frame = CGRect(origin: self.startRecording.layoutMarginsGuide.layoutFrame.origin, size: CGSize(width: viewFrame.width, height: viewFrame.height))
        let path = UIBezierPath(arcCenter: center, radius: viewFrame.width/2, startAngle: -.pi/2, endAngle: .pi * 2, clockwise: true).cgPath
        circleShape.path = path
        self.startRecording.layer.addSublayer(circleShape)
        
        
        let circleAnimation = CABasicAnimation(keyPath: "transform.scale")
        circleAnimation.fromValue = 1.4
        circleAnimation.toValue = 1.2
        circleAnimation.duration = 1
        circleAnimation.autoreverses = true
        circleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        circleAnimation.repeatCount = .infinity
        circleShape.add(circleAnimation, forKey: "circleAimation")
        
        
        
    }
}

