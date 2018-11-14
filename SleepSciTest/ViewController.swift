//
//  ViewController.swift
//  SleepSciTest
//
//  Created by Alexander Kudlak on 11/12/18.
//  Copyright © 2018 Alexandr Kudlak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var squareView: SquareView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        squareView.delegate = self
    }
}

extension ViewController: SquareViewDelegate {
    func updateRemaining(time: String) {
        remainingTimeLabel.text = time
    }
    
    func toggleRemainingTimeVisibility() {
        remainingTimeView.isHidden.toggle()
    }
}
