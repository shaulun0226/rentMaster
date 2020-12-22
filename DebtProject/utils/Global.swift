//
//  Global.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/3.
//
import UIKit
import Foundation
class Global{
    static let URL:String = "http://35.184.167.119:3000/api";
    static let BACKGROUND_COLOR = [UIColor(named: "GradientBegin")?.cgColor
                                   ,UIColor(named: "GradientEnd")?.cgColor] ;
    
    
    static func setBackgroundColor(_ view:UIView)->CAGradientLayer{
        let layer = CAGradientLayer();
        layer.frame = view.bounds;
        layer.colors = BACKGROUND_COLOR as [Any]
        layer.startPoint = CGPoint(x: 0.5,y: 0);
        layer.endPoint = CGPoint(x: 0.5,y: 1);
        return layer;
    }
}

