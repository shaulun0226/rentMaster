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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
