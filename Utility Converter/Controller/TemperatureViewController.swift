//
//  TemperatureViewController.swift
//  Utility Converter
//
//  Created by Chaveen Ellawela on 2021-02-10.
//

import Foundation
import UIKit

enum TemperatureUnits: Int {
    case farenheit, celsius, kelvin
}

class TemperatureViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldFahrenheit: UITextField!
    @IBOutlet weak var textFieldCelsius: UITextField!
    @IBOutlet weak var textFieldKelvin: UITextField!
    @IBOutlet weak var customKeyboard: CustomKeyboard!
    
    var temperature : Temperature = Temperature()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.assignDelegates()
        resetTextFieldsToDefaultSate()
        disableDefaultKeyboard()
        retrievingDataInAppOpen()
    }
    
    
    private func setupUI(){
        textFieldFahrenheit.layer.borderWidth = 1
        textFieldFahrenheit.layer.borderColor = UIColor.darkGray.cgColor
        textFieldFahrenheit.layer.cornerRadius = 10
        
        textFieldCelsius.layer.borderWidth = 1
        textFieldCelsius.layer.borderColor = UIColor.darkGray.cgColor
        textFieldCelsius.layer.cornerRadius = 10
        
        textFieldKelvin.layer.borderWidth = 1
        textFieldKelvin.layer.borderColor = UIColor.darkGray.cgColor
        textFieldKelvin.layer.cornerRadius = 10
    }
    override func viewWillDisappear(_ animated: Bool) {
        savingDataInAppClose()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        customKeyboard.activeTextField = textField
    }
    
    func assignDelegates() {
        textFieldFahrenheit.delegate = self
        textFieldCelsius.delegate = self
        textFieldKelvin.delegate = self
    }
    
    
    @IBAction func temperatureViewTextFieldValueChanged(_ sender: UITextField) {
        
        // validation check for empty text fields
        if (sender.text == Constants.DEFAULT_TEXT_FIELD_VALUE){
            resetTextFieldsToDefaultSate()
        } else {
            guard let textFieldValue = sender.text else { return displayAlertView(alertTitle: Alerts.CommonAlert.TITLE, alertDescription: Alerts.CommonAlert.MESSAGE)}
            guard let doubleTextFieldValue = Double(textFieldValue) else {  return displayAlertView(alertTitle: Alerts.InvalidParameters.TITLE, alertDescription: Alerts.InvalidParameters.MESSAGE) }
            
            switch TemperatureUnits(rawValue: sender.tag)! {
            
            case .farenheit:
                let temperatureUnitObjForFahrenheit = Measurement(value:doubleTextFieldValue, unit: UnitTemperature.fahrenheit)
                temperature.farenheit = temperatureUnitObjForFahrenheit.value
                temperature.celsius = temperatureUnitObjForFahrenheit.converted(to: .celsius).value
                temperature.kelvin = temperatureUnitObjForFahrenheit.converted(to: .kelvin).value
                
                textFieldCelsius.text = "\(formatTextFieldValue(data: temperature.celsius))"
                textFieldKelvin.text = "\(formatTextFieldValue(data: temperature.kelvin))"
            case .celsius:
                let temperatureUnitObjForCelsius = Measurement(value:doubleTextFieldValue, unit: UnitTemperature.celsius)
                temperature.celsius = temperatureUnitObjForCelsius.value
                temperature.farenheit = temperatureUnitObjForCelsius.converted(to: .fahrenheit).value
                temperature.kelvin = temperatureUnitObjForCelsius.converted(to: .kelvin).value
                
                textFieldFahrenheit.text = "\(formatTextFieldValue(data: temperature.farenheit))"
                textFieldKelvin.text = "\(formatTextFieldValue(data: temperature.kelvin))"
                
            case .kelvin:
                let temperatureUnitObjForLelvin = Measurement(value:doubleTextFieldValue, unit: UnitTemperature.kelvin)
                temperature.kelvin = temperatureUnitObjForLelvin.value
                temperature.celsius = temperatureUnitObjForLelvin.converted(to: .celsius).value
                temperature.farenheit = temperatureUnitObjForLelvin.converted(to: .fahrenheit).value
                
                textFieldCelsius.text = "\(formatTextFieldValue(data: temperature.celsius))"
                textFieldFahrenheit.text = "\(formatTextFieldValue(data: temperature.farenheit))"
            }
        }
        
    }
    
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        if(textFieldFahrenheit.text != Constants.DEFAULT_TEXT_FIELD_VALUE && textFieldCelsius.text != Constants.DEFAULT_TEXT_FIELD_VALUE && textFieldKelvin.text != Constants.DEFAULT_TEXT_FIELD_VALUE){
            DataManagementStore.saveDataToStore(key: StoreKeys.Temperature.PRIMARY_KEY, value: temperature.getTemperatureData())
            showToast(message: Alerts.ValidSaveAttempt.TITLE, seconds: 0.8)
        } else {
            displayAlertView(alertTitle: Alerts.InvalidSaveAttempt.TITLE, alertDescription: Alerts.InvalidSaveAttempt.MESSAGE)
        }
    }
    
    
    @IBAction func historyBtnPressed(_ sender: UIBarButtonItem) {
        
        let storage = DataManagementStore.getSavedDataFromStore(key: StoreKeys.Temperature.PRIMARY_KEY)
        if(storage.count > 0){
            // laoding history page with related history data
            let destination = storyboard?.instantiateViewController(withIdentifier: "historyView") as! HistoryViewController
            destination.storage = storage
            destination.storageType = StoreKeys.Temperature.PRIMARY_KEY
            self.present(destination, animated: true, completion: nil)
        }else{
            displayAlertView(alertTitle: Alerts.NoHistory.TITLE, alertDescription: Alerts.NoHistory.MESSAGE)
        }
    }
    
    // saving available data in the text fields when app closing
    func savingDataInAppClose(){
        defaults.set(textFieldFahrenheit.text, forKey: StoreKeys.Temperature.PRESENT_VALUE_FAHRENHEIT)
        defaults.set(textFieldCelsius.text, forKey: StoreKeys.Temperature.PRESENT_VALUE_CELSIUS)
        defaults.set(textFieldKelvin.text, forKey: StoreKeys.Temperature.PRESENT_VALUE_KELVIN)
        defaults.synchronize()
    }
    
    //  retrieving saved data for text fields when app opening
    func retrievingDataInAppOpen(){
        textFieldFahrenheit.text = defaults.string(forKey: StoreKeys.Temperature.PRESENT_VALUE_FAHRENHEIT)
        textFieldCelsius.text = defaults.string(forKey: StoreKeys.Temperature.PRESENT_VALUE_CELSIUS)
        textFieldKelvin.text = defaults.string(forKey: StoreKeys.Temperature.PRESENT_VALUE_KELVIN)
        
    }
    
    // reseting text fields to default sate
    func resetTextFieldsToDefaultSate(){
        textFieldFahrenheit.text = Constants.DEFAULT_TEXT_FIELD_VALUE
        textFieldCelsius.text = Constants.DEFAULT_TEXT_FIELD_VALUE
        textFieldKelvin.text = Constants.DEFAULT_TEXT_FIELD_VALUE
    }
    
    // disabling the default keyboard
    func disableDefaultKeyboard(){
        textFieldFahrenheit.inputView = UIView()
        textFieldCelsius.inputView = UIView()
        textFieldKelvin.inputView = UIView()
    }
    
    // formatting value into decimal points
    func formatTextFieldValue(data : Double) -> String {
        return String(data.roundToDecimal(defaults.integer(forKey: StoreKeys.DECIMAL_VALUE_KEY)))
    }
    
}
