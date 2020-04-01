//
//  SheetViewCell.swift
//  demo
//
//  Created by lanyee-ios2 on 2020/3/31.
//  Copyright © 2020 lanyee-ios2. All rights reserved.
//

import UIKit

open class SheetViewCell: UICollectionViewCell {
    
    open var itemWidth:CGFloat = 0
    
    open lazy var titleLab : UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    open lazy var markView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 2.5
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open var sectiondata:Any? = nil
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.selectedBackgroundView = UIView.init()
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func setup() {
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.markView)
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[markView(5)][titleLab]", options: [], metrics: nil, views: ["markView":self.markView,"titleLab":self.titleLab]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[markView(5)]-2-|", options: [], metrics: nil, views: ["markView":self.markView]))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.titleLab, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-7-[lab]-7-|", options: [], metrics: nil, views: ["lab":self.titleLab]))
        
        
        
    }
    
    override open func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let Attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        if self.itemWidth == 0 {return Attributes}
        Attributes.frame.size.width = self.itemWidth
        return Attributes
    }
}
