//
//  PickerViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/21.
//

import UIKit

class PickerViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int, forComponent component: Int)
    -> String? {
        return pickerData[row]
    }
}
