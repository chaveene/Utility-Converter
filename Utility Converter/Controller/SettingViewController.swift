//
//  SettingViewController.swift
//  Utility Converter
//
//  Created by Chaveen Ellawela on 2021-02-14.
//

import Foundation
import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var roundUpDecimalNumberSegementController: UISegmentedControl!
    @IBOutlet weak var roundUpDecimalTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var settingDescription: UITextView!
    @IBOutlet weak var customKeyboard: CustomKeyboard!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        setupUI()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        customKeyboard.activeTextField = textField
    }
    func assignDelegates() {
        roundUpDecimalTextField.delegate = self
    }
    
    private func setupUI(){
        roundUpDecimalTextField.layer.borderWidth = 1
        roundUpDecimalTextField.layer.borderColor = UIColor.darkGray.cgColor
        roundUpDecimalTextField.layer.cornerRadius = 10
        settingDescription.text = NSLocalizedString("SettingDescription", comment: "")
        
        if(defaults.integer(forKey: "roundup_decimalnumber") > 4) {
            roundUpDecimalNumberSegementController.selectedSegmentIndex = defaults.integer(forKey: "roundup_decimalnumber") - 1
        } else {
            roundUpDecimalNumberSegementController.selectedSegmentIndex = 3
        }
        
        roundUpDecimalTextField.isHidden = true
        saveBtn.isHidden = true
    }
    
    @IBAction func segementControllerValueChanged(_ sender: UISegmentedControl) {
        
        if(roundUpDecimalNumberSegementController.selectedSegmentIndex == 0)
        {
            defaults.set(1, forKey: "roundup_decimalnumber")
            roundUpDecimalNumberSegementController.selectedSegmentIndex = 0
        }
        else if(roundUpDecimalNumberSegementController.selectedSegmentIndex == 1)
        {
            defaults.set(2, forKey: "roundup_decimalnumber")
            roundUpDecimalNumberSegementController.selectedSegmentIndex = 1
        }else if (roundUpDecimalNumberSegementController.selectedSegmentIndex == 2)
        {
            defaults.set(3, forKey: "roundup_decimalnumber")
            roundUpDecimalNumberSegementController.selectedSegmentIndex = 2
        } else{
            roundUpDecimalNumberSegementController.selectedSegmentIndex = 4
            roundUpDecimalTextField.isHidden = false
            saveBtn.isHidden = false
            roundUpDecimalTextField.text = String(defaults.integer(forKey: "roundup_decimalnumber"))
        }
    }
    
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if let number = Int(roundUpDecimalTextField.text!) {
            if (number < Int(NSLocalizedString("RoundUpDecimalMaxAmout", comment: "")) ?? 5) {
                defaults.set(number, forKey: "roundup_decimalnumber")
                dismiss(animated: true, completion: nil)
            } else {
                displayAlert(title: NSLocalizedString("FailAlertMsgTitle", comment: ""), message: NSLocalizedString("RoundUpDecimalMaxAmoutExceedMsgDescription", comment: ""))
            }
            
        }else{
            displayAlert(title: NSLocalizedString("FailAlertMsgTitle", comment: ""), message: NSLocalizedString("SettingChangedFailedMsgDescription", comment: ""))
        }
    }
    
    
}