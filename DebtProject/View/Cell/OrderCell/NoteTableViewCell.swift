//
//  NoteTableViewCell.swift
//  DebtProject
//
//  Created by allenhung on 2021/1/7.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var lbNoteUserName:UILabel!
    @IBOutlet weak var lbNoteDate:UILabel!
    @IBOutlet weak var lbNoteTime:UILabel!
    @IBOutlet weak var lbNoteMessage:UILabel!
    
    var wishItemWeightPrice:Float = 0.0
    //陰影
    var shadowOffsetWidth: Int = 2//偏移量
    var shadowOffsetHeight: Int = 2//偏移量
    var shadowColor: UIColor? =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //陰影顏色
    var shadowOpacity: Float = 0.6//陰影的透明度
    var cornerRadius: CGFloat = 10
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = cornerRadius
        //設定陰影
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5//調整y起點
            frame.origin.x = 10//調整x起點
            frame.size.height -= 15//調整高度
            frame.size.width -= 2 * frame.origin.x//調整寬度
            super.frame = frame
        }
    }
    func conficgure(with model:NoteModel){
        lbNoteUserName.text = model.senderName
        lbNoteMessage.text = model.message
        let timeTmp = model.createTime.split(separator: "T")
        if(timeTmp.count<2){
            return
        }
        lbNoteDate.text = String(timeTmp[0])
        lbNoteTime.text = String(timeTmp[1])
    }
}
