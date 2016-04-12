//
//  LTSelectionViewCell.swift
//  SelectionExample
//
//  Created by liu ting on 16/4/11.
//  Copyright © 2016年 liu ting. All rights reserved.
//

import UIKit

class LTSelectionViewCell: UIView {
    
    var defaultImage = UIImage(named:"defaultImage")
    var highlightImage = UIImage(named:"highlightImage")
    
    private var backgroundImageView = UIImageView(image: UIImage(named: "defaultImage"))
    private var label = UILabel()
    
    private var title = "" {
        didSet{
            label.text = title
        }
    }
    
    var selected = false {
        didSet{
            if selected{
                self.backgroundImageView.image = highlightImage
            } else {
                self.backgroundImageView.image = defaultImage
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }
    //以title初始化
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
        self.title = title
        setUpSubViews()
    }
    //以title和image初始化
    convenience init(frame: CGRect, title: String, defaultImage: UIImage, highlightImage: UIImage) {
        self.init(frame: frame)
        self.title = title
        self.defaultImage = defaultImage
        self.highlightImage = highlightImage
        setUpSubViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpSubViews() {
        //设置背景图片
        backgroundImageView.image = defaultImage
        backgroundImageView.userInteractionEnabled = false
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.addSubview(backgroundImageView)
        //设置label
        label.text = title
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = NSTextAlignment.Left
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.userInteractionEnabled = false
        
        self.addSubview(label)
        setUpConstraints()
    }
    
    //添加约束
    func setUpConstraints() {
        for view in self.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        self.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1
            , constant: 0))
        self.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1
            , constant: 0))
        self.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1
            , constant: 0))
        self.addConstraint(NSLayoutConstraint(item: backgroundImageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1
            , constant: 0))
        //label的宽度设置为self的0.8, 左右留白
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.8, constant: 0))
        

    }
    //用户点击了cell
    func cellDidTapped() {
        selected = !selected
    }  

}
