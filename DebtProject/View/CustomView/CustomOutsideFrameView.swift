//
//  CustomOutsideFrameView.swift
//  DebtProject
//
//  Created by allenhung on 2020/12/30.
//

import UIKit

class CustomOutsideFrameView: UIView {

    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5//調整y起點
            frame.origin.x = 15//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * frame.origin.x//調整寬度
            super.frame = frame
        }
    }
    override func layoutSubviews() {
        layer.backgroundColor = UIColor(named: "card")?.cgColor
    }
}
