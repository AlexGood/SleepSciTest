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
}

class ViewController: UIViewController {
    
    @IBOutlet weak var breetheContainer: UIView!
    @IBOutlet weak var animatingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    private let animationDuration: TimeInterval = 2
    private var breathType: BreathType = .prepare
    
    private var breathData = [BreathData]()
    
    private var timer: Timer!
    private var seconds = 10
    
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
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        seconds -= 1
        timerLabel.text = "\(seconds)"
        if seconds < 1 {
            timer.invalidate()
        }
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: animationDuration, animations: {
            switch self.breathType {
            case .prepare:
                self.animateBreathSquare(with: .prepare)
                self.breathType = .inhale
            case .inhale:
                self.animateBreathSquare(with: .inhale)
                self.breathType = .exhale
            case .exhale:
                self.animateBreathSquare(with: .exhale)
                self.breathType = .inhale
            }
        }, completion: { _ in
            self.startAnimation()
        })
    }
    
    //MARK:- IBActions
    @IBAction func startBreathing(_ sender: UIButton) {
        startTimer()
        startAnimation()
    }
}
