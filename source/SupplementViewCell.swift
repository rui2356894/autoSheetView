//
//  SupplementViewCell.swift
//  demo
//
//  Created by lanyee-ios2 on 2020/3/31.
//  Copyright © 2020 lanyee-ios2. All rights reserved.
//

import UIKit

var CORNER_RADIUS: CGFloat = 2.5

open class SupplementViewCell: UICollectionViewCell {
    
    open lazy var leftBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = CORNER_RADIUS
        return btn
    }()
    
    open lazy var leftMiddleBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = CORNER_RADIUS
        return btn
    }()
    
    open lazy var rightBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = CORNER_RADIUS
        return btn
    }()
    
    open lazy var rightMiddleBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.layer.cornerRadius = CORNER_RADIUS
        return btn
    }()
    
    open var btnBGColor:UIColor = UIColor.red {
        didSet {
            self.themeDidChanged()
        }
    }
    
    open var btnTextColor:UIColor = UIColor.white {
        didSet {
            self.themeDidChanged()
        }
    }
    
    open var sectiondata:Any? = nil
    
    lazy open var lineView : UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.themeDidChanged()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func setup(){
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.leftBtn)
        self.contentView.addSubview(self.leftMiddleBtn)
        self.contentView.addSubview(self.rightBtn)
        self.contentView.addSubview(self.rightMiddleBtn)
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView]|", options: [], metrics: nil, views: ["lineView":self.lineView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: [], metrics: nil, views: ["lineView":self.lineView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[leftBtn]-10-[leftMiddleBtn(leftBtn)]-10-[rightMiddleBtn(leftBtn)]-10-[rightBtn(leftBtn)]-10-|", options: [], metrics: nil, views: ["leftBtn":self.leftBtn,"leftMiddleBtn":self.leftMiddleBtn,"rightMiddleBtn":self.rightMiddleBtn,"rightBtn":self.rightBtn]))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.leftBtn, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.5, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.leftMiddleBtn, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.5, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.rightMiddleBtn, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.5, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.rightBtn, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.5, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.rightBtn, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.rightMiddleBtn, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.leftMiddleBtn, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.leftBtn, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
     func themeDidChanged (){
        self.setBtnTheme(btn: self.leftBtn)
        self.setBtnTheme(btn: self.leftMiddleBtn)
        self.setBtnTheme(btn: self.rightBtn)
        self.setBtnTheme(btn: self.rightMiddleBtn)
    }
    
    func setBtnTheme(btn:UIButton) {
        btn.setTitleColor(btnTextColor, for: .normal)
        //btn.layer.borderColor = btnTextColor.cgColor
//        btn.setBackgroundImage(UIImage.pureColorImage(color:btnBGColor), for: .normal)
    }
    
}
