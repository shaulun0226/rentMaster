//
//  CustomAlertViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/31.
//

import UIKit

class CustomAlertViewController: PresentMiddleVC {

    @IBOutlet weak var lbAlertTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    init(title:String,hasConfirm:Bool,hasCancel:Bool){
//        lbAlertTitle.text = title
//        (hasCancel) ? (btnCancel.isHidden = false) : (btnConfirm.isHidden = true)
//        (hasConfirm) ? (btnConfirm.isHidden = false) : (btnConfirm.isHidden = true)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}
