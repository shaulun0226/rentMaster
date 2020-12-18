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
    static let BACKGROUND_COLOR = [#colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.3411764706, alpha: 1).cgColor,#colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1).cgColor] ;
    
    
    static func setBackgroundColor(_ view:UIView)->CAGradientLayer{
        let layer = CAGradientLayer();
        layer.frame = view.bounds;
        layer.colors = BACKGROUND_COLOR
        layer.startPoint = CGPoint(x: 0.5,y: 0);
        layer.endPoint = CGPoint(x: 0.5,y: 1);
        return layer;
    }
}

