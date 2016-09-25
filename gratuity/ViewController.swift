//
//  ViewController.swift
//  gratuity
//
//  Created by emersonmalca on 9/24/16.
//  Copyright © 2016 Emerson Malca. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bottomStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var gratuityContainer: UIView!
    @IBOutlet weak var totalContainer: UIView!
    @IBOutlet weak var gratuityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billCurrencySignLabel: UILabel!
    @IBOutlet weak var billCurrencySignWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    
    var didShowFullInterface = false
    let tipOptions = [0.15, 0.18, 0.2]
    var selectedTipOptionIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Don't show gratuity or total in the beginning
        gratuityContainer.isHidden = true
        totalContainer.isHidden = true
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        // Show keyboard
        billTextField.becomeFirstResponder()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func textFieldDidChange(_ sender: AnyObject) {
        // Calculate tip
        calculateTip()
        
        // Show full interface if we haven't yet
        if !didShowFullInterface {
            didShowFullInterface = true
            
            // Update tip percentage to selected option
            changeTipPercentage(toIndex: selectedTipOptionIndex)
            
            // Show the other 2 sections
            showFullInterface()
        }
        
    }
    
    @IBAction func onDecreaseTip(_ sender: AnyObject) {
        changeTipPercentage(toIndex: selectedTipOptionIndex-1)
    }
    
    @IBAction func onIncreaseTip(_ sender: AnyObject) {
        changeTipPercentage(toIndex: selectedTipOptionIndex+1)
    }
    
    func changeTipPercentage(toIndex: Int) {
        guard toIndex >= 0 && toIndex < tipOptions.count else {
            return
        }

        selectedTipOptionIndex = toIndex
        let percent = tipOptions[toIndex]
        tipPercentageLabel.text = String(format: "%.0f%%", percent*100.0)
        
        // Recalculate
        calculateTip()

    }
    
    func calculateTip() {
        
        let billAmount = Double(billTextField.text!) ?? 0.0
        let percent = tipOptions[selectedTipOptionIndex]
        let tip = billAmount * percent
        let total = billAmount + tip
        
        gratuityLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    func showFullInterface() {
        
        // Reduce the font size of total bill
        billCurrencySignLabel.font = gratuityLabel.font
        billTextField.font = gratuityLabel.font
        let width = billCurrencySignLabel.sizeThatFits(billCurrencySignLabel.bounds.size).width
        billCurrencySignWidthConstraint.constant = width
        
        // Animate other container into view
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3.0, options: .beginFromCurrentState, animations: {
            self.gratuityContainer.isHidden = false
            self.totalContainer.isHidden = false
            self.billCurrencySignLabel.layoutIfNeeded()
            }, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let frame = frameValue.cgRectValue
            bottomStackViewConstraint.constant = frame.size.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

}

