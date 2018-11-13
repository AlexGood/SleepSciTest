//
//  ViewController.swift
//  SleepSciTest
//
//  Created by Alexander Kudlak on 11/12/18.
//  Copyright © 2018 Alexandr Kudlak. All rights reserved.
//

import UIKit

//Test enum
private enum BreathType: CGFloat {
    case inhale = 1
    case prepare = 0.75
    case exhale = 0.5
    case hold = 0
}

class ViewController: UIViewController {
    
    @IBOutlet weak var breetheContainer: UIView!
    @IBOutlet weak var animatingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    private var breathType: BreathType = .prepare
    
    private var breathData = [BreathData]()
    
    private var timer: Timer!
//    private var seconds = 10
    
    private var breathPosition = 0
    private var hold: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimatingView()
        setupData()
    }
    
    //MARK:- Private
    private func setupAnimatingView() {
        animateBreathSquare(with: .inhale)
    }
    
    private func setupData() {
        if let breathData = BreathData.getJsonData() {
            self.breathData = breathData
        }
    }
    
    private func animateBreathSquare(with scalePoint: BreathType) {
        let scale = scalePoint.rawValue
        animatingView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
//    private func startTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
//    }
    
//    @objc private func updateTimer() {
//        seconds -= 1
//        timerLabel.text = "\(seconds)"
//        if seconds < 1 {
//            timer.invalidate()
//        }
//    }
    
    private func setType(with type: String) {
        if type == "inhale" {
            breathType = .inhale
        } else if type == "exhale" {
            breathType = .exhale
        } else {
            breathType = .hold
        }
    }
    
    private func startAnimation(with data: BreathData) {
        
        setType(with: data.type)
        
        let duration = data.duration
        
        UIView.animate(withDuration: duration, delay: hold, animations: {
            self.hold = 0
            switch self.breathType {
            case .prepare:
                self.animateBreathSquare(with: .prepare)
            case .inhale:
                self.animateBreathSquare(with: .inhale)
            case .exhale:
                self.animateBreathSquare(with: .exhale)
            case .hold:
                self.hold = duration
            }
        }, completion: { _ in
            self.breathPosition += 1
            if self.breathPosition < self.breathData.count {
                self.startAnimation(with: self.breathData[self.breathPosition])
            }
        })
    }
    
    private func startBreathing() {
        self.startAnimation(with: self.breathData.first!)
    }
    
    //MARK:- IBActions
    @IBAction func prepareForBreathing(_ sender: UIButton) {
        //        startTimer()
        UIView.animate(withDuration: 2, animations: {
            self.animateBreathSquare(with: .prepare)
        }, completion: { _ in
            self.startBreathing()
        })
    }
}
