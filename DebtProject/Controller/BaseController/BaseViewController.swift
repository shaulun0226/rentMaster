//
//  BaseViewController.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/15.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //設定navigation bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1)
        //設定barItem 的顏色
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
//        let BACKGROUND_COLOR = [#colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1).cgColor,#colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1).cgColor] ;
        let layer = Global.setBackgroundColor(view);
//        let layer = CAGradientLayer();
//        layer.frame = view.bounds;
//        layer.colors = BACKGROUND_COLOR
//        layer.startPoint = CGPoint(x: 0.5,y: 0);
//        layer.endPoint = CGPoint(x: 0.5,y: 1);
//        let layer = Global.setBackgroundColor(view);
        view.layer.insertSublayer(layer, at: 0)
        // Do any additional setup after loading the view.
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
