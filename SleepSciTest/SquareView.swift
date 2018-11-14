//
//  SquareView.swift
//  SleepSciTest
//
//  Created by Alexander Kudlak on 11/14/18.
//  Copyright © 2018 Alexandr Kudlak. All rights reserved.
//

import UIKit

protocol SquareViewDelegate: class {
    func updateRemaining(time: String)
    func toggleRemainingTimeVisibility()
}

private enum BreathType: CGFloat {
    case inhale = 1
    case prepare = 0.75
    case exhale = 0.5
    case hold = 0
}

class SquareView: UIView {
    @IBOutlet weak var animatingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var squareButton: UIButton!
    
    private var breathType: BreathType = .prepare
    private var breathData = [BreathData]()
    
    private var timer: Timer!
    private var seconds: TimeInterval = 0
    private var defaultDuration: TimeInterval = 2
    private var duration: TimeInterval = 0
    private var remainingTime: TimeInterval = 0
    
    private var breathPosition = 0
    
    weak var delegate: SquareViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAnimatingView()
        setupData()
    }
    
    //MARK:- Private
    private func setupAnimatingView() {
        animateBreathSquare(with: .inhale)
    }
    
    private func animateBreathSquare(with scalePoint: BreathType) {
        let scale = scalePoint.rawValue
        if scale != 0 {
            animatingView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    private func setupData() {
        if let breathData = BreathData.getJsonData() {
            self.breathData = breathData
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTime() {
        if seconds >= 0 {
            self.remainingTime -= 1
            delegate.updateRemaining(time: timeToString(data: self.remainingTime))
            
            timerLabel.text = timeToString(data: seconds)
            self.seconds -= 1
        } else if breathType == .hold{
            animateSquare(with: .hold)
        }
    }
    
    private func calculateRemainingTime() {
        
        for object in breathData {
            remainingTime += object.duration + 1
        }
        
        delegate.updateRemaining(time: timeToString(data: remainingTime))
    }
    
    private func timeToString(data: TimeInterval) -> String {
        let minutes = Int(data) / 60 % 60
        let second = Int(data) % 60
        
        return String(format:"%02i:%02i", minutes, second)
    }
    
    private func setType(with type: String) {
        if type == "inhale" {
            breathType = .inhale
        } else if type == "exhale" {
            breathType = .exhale
        } else {
            breathType = .hold
        }
    }
    
    private func updateUI(with data: BreathData) {
        setType(with: data.type)
        
        //+ 1 to show 00:00 position as on animation
        duration = data.duration + 1
        animatingView.backgroundColor = UIColor(hex: data.color)
        titleLabel.text = data.type.uppercased()
        
        self.seconds = data.duration
        updateTime()
    }
    
    private func setupAnimation(with data: BreathData) {
        
        updateUI(with: data)
        
        switch self.breathType {
        case .prepare:
            self.animateSquare(with: .prepare)
        case .inhale:
            self.animateSquare(with: .inhale)
        case .exhale:
            self.animateSquare(with: .exhale)
        case .hold: break
        }
    }
    
    private func animateSquare(with data: BreathType) {
        UIView.animate(withDuration: duration, animations: {
            self.animateBreathSquare(with: data)
        }, completion: { _ in
            self.breathPosition += 1
            if self.breathPosition < self.breathData.count {
                self.setupAnimation(with: self.breathData[self.breathPosition])
            } else {
                self.endBreathing()
            }
        })
    }
    
    private func endBreathing() {
        self.timer.invalidate()
        
        self.timerLabel.text = ""
        self.titleLabel.text = ""
        
        self.delegate.toggleRemainingTimeVisibility()
        
        UIView.animate(withDuration: defaultDuration, animations: {
            self.animateBreathSquare(with: .inhale)
        }, completion: { _ in
            self.timerLabel.text = ""
            self.titleLabel.text = "TAP HERE TO BREATHE"
            self.animatingView.backgroundColor = UIColor.yellow
            self.squareButton.isEnabled.toggle()
            self.breathPosition = 0
        })
    }
    
    private func startBreathing() {
        self.setupAnimation(with: self.breathData.first!)
    }
    
    //MARK:- IBActions
    @IBAction func prepareForBreathing(_ sender: UIButton) {
        squareButton.isEnabled.toggle()
        
        titleLabel.text = ""
        timerLabel.text = ""
        animatingView.backgroundColor = .customAqua
        
        UIView.animate(withDuration: defaultDuration, animations: {
            self.animateBreathSquare(with: .prepare)
        }, completion: { _ in
            self.startBreathing()
            self.startTimer()
            self.calculateRemainingTime()
            self.delegate.toggleRemainingTimeVisibility()
        })
    }
}
