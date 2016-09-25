//
//  SettingsViewController.swift
//  gratuity
//
//  Created by emersonmalca on 9/25/16.
//  Copyright © 2016 Emerson Malca. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultPercentLabel: UILabel!
    var selectedTipOptionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the default gratuity index
        selectedTipOptionIndex = GratuityHelper.defaultTipIndex()
        let percent = GratuityHelper.tipOptions[selectedTipOptionIndex]
        updatePercentLabel(withPercent: percent)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func onDecreaseGratuity(_ sender: AnyObject) {
        changeTipPercentage(toIndex: selectedTipOptionIndex-1)
    }
    
    @IBAction func onIncreaseGratuity(_ sender: AnyObject) {
        changeTipPercentage(toIndex: selectedTipOptionIndex+1)
    }
    
    func changeTipPercentage(toIndex index: Int) {
        guard index >= 0 && index < GratuityHelper.tipOptions.count else {
            return
        }
        
        selectedTipOptionIndex = index
        let percent = GratuityHelper.tipOptions[index]
        updatePercentLabel(withPercent: percent)
        
        // Also update the persistant value
        GratuityHelper.defaultTip = percent
    }
    
    func updatePercentLabel(withPercent percent: Double) {
        defaultPercentLabel.text = String(format: "%.0f%%", percent*100.0)
    }
}
