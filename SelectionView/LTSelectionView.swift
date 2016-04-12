//
//  LTSelectionView.swift
//  SelectionExample
//
//  Created by liu ting on 16/4/11.
//  Copyright © 2016年 liu ting. All rights reserved.
//

import UIKit

@objc protocol LTSelectionViewDelegate {
    
    func numberOfRowsForSelectionView(selectionView: LTSelectionView) -> Int
    func optionTitleForRowAtIndex(selectionView: LTSelectionView, index: Int) -> String
    func selectionHeaderTitle(selectionView: LTSelectionView) -> String
    func didSelectedRowAtIndex(selectionView: LTSelectionView, index:Int)
    optional func initialSelectionIndex(selectionView: LTSelectionView) -> [Int]
    optional func rowHeightForSelectionCells(selectionView: LTSelectionView) -> CGFloat
}

class LTSelectionView: UIView{

    weak var delegate: LTSelectionViewDelegate? {
        didSet{
            reloadData()
        }
    }
    
    private var backgroundScrollView = UIScrollView()
    private var headerLabel = UILabel()
    private var selectionCells = [LTSelectionViewCell]()
    private var rowHeight:CGFloat = 40
    
    var defaultImage:UIImage?
    var highlightImage:UIImage?
    
    var isMultiSelection = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSelectionView()
    }
    
    convenience init(frame:CGRect, isMultiSelection:Bool, defaultImage:UIImage, highlightImage:UIImage){
        self.init(frame: frame)

        self.isMultiSelection = isMultiSelection
        self.defaultImage = defaultImage
        self.highlightImage = highlightImage
        setUpSelectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        print("awake from nib")
        setUpSelectionView()
    }
    
    private func setUpSelectionView(){
        
        //背景view设置为scroll view
        backgroundScrollView.bounces = false
        backgroundScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundScrollView)

        //设置Header View，添加约束
        setUpHeaderView()
        setUpConstraints()
        
        //添加Tap手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LTSelectionView.didTappedOnScrollView(_:)))

        backgroundScrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //添加约束
    private func setUpConstraints(){
        let views:[String:UIView] = ["backgroundScrollView":backgroundScrollView]
        //水平约束
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[backgroundScrollView]-0-|",
            options: [],
            metrics: nil,
            views: views)
        //垂直约束
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[backgroundScrollView]-0-|",
            options: [],
            metrics: nil,
            views: views)
        let allConstraints = horizontalConstraint + verticalConstraint
        self.addConstraints(allConstraints)
    }
    
    //处理手势响应
    @objc private func didTappedOnScrollView(gesture:UIGestureRecognizer){
        
        let location = gesture.locationInView(gesture.view)
        //如果约束已经实现，则执行判断
        if let delegate = self.delegate {
            
            let views = backgroundScrollView.subviews
            
            for index in 1..<views.count {
                
                let view = views[index]
                
                //如果Tap location在某个cell中，则判定用户选定了该cell
                if CGRectContainsPoint(view.frame, location) {
                    
                    delegate.didSelectedRowAtIndex(self, index: index - 1)
                    //将选定的cell 设为高亮
                    for i in 0..<selectionCells.count {
                        
                        //如果是多选状态，则将选中的cell 高亮
                        if isMultiSelection {
                            if i == index - 1 {
                                selectionCells[i].cellDidTapped()
                            }
                        }
                        //如果是单选状态，则将选中cell高亮的同时将其他cell 取消高亮
                        else {
                            if i == index - 1 {
                                selectionCells[i].cellDidTapped()
                            }
                            else {
                                selectionCells[i].selected = false
                            }
                        }

                    }
                }
            }
        }
        
    }
    //设置header Label
    func setUpHeaderView() {
        headerLabel.font = UIFont.systemFontOfSize(17)
        headerLabel.textAlignment = NSTextAlignment.Left
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = ""
        
        backgroundScrollView.addSubview(headerLabel)
        
        //添加约束
        backgroundScrollView.addConstraint(NSLayoutConstraint(item: headerLabel, attribute: .CenterX, relatedBy: .Equal, toItem: backgroundScrollView, attribute: .CenterX, multiplier: 1, constant: 0))
        
        backgroundScrollView.addConstraint(NSLayoutConstraint(item: headerLabel, attribute: .Width, relatedBy: .Equal, toItem: backgroundScrollView, attribute: .Width, multiplier: 0.93, constant: 0))
        
        backgroundScrollView.addConstraint(NSLayoutConstraint(item: headerLabel, attribute: .Top, relatedBy: .Equal, toItem: backgroundScrollView, attribute: .Top, multiplier: 1, constant: 10))
        
    }
    //重新加载数据
    func reloadData() {
        
        if let delegate = self.delegate{
            //首先去掉之前所有的cell
            for subview in backgroundScrollView.subviews {
                if subview == headerLabel {
                    continue
                }
                subview.removeFromSuperview()
            }
            
            //设置header label
            headerLabel.text = delegate.selectionHeaderTitle(self)
            
            //添加cells
            for index in 0..<delegate.numberOfRowsForSelectionView(self) {
               
                let optionTitle = delegate.optionTitleForRowAtIndex(self, index: index)
                var cell = LTSelectionViewCell()
                
                //如果用户设定了图片，则使用用户图片，否则使用默认图片
                if (defaultImage != nil && highlightImage != nil) {
                    cell = LTSelectionViewCell(frame: CGRectMake(0, 0, 300, 40), title: optionTitle, defaultImage: defaultImage!, highlightImage: highlightImage!)
                }
                else {
                    cell = LTSelectionViewCell(frame: CGRectMake(0, 0, 300, 40), title: optionTitle)
                }
                backgroundScrollView.addSubview(cell)
                selectionCells.append(cell)
            }
            //给cells 添加约束
            let views = backgroundScrollView.subviews
            for i in 1..<views.count {
                let view = views[i]
                view.translatesAutoresizingMaskIntoConstraints = false
                let preview = views[i - 1]
                var rowPadding:CGFloat = 0
                //第一个cell与header label之间的间隙设置为10，cell与cell间间隙为0
                if i == 1 {
                    rowPadding = 10
                }
                //如果用户指定了row height，则设定Row Height，否则设为默认值
                if let userdefinedRowHeight = delegate.rowHeightForSelectionCells?(self) {
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: userdefinedRowHeight))
                }
                else {
                    view.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.11, constant: 0))
                }

                
                backgroundScrollView.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: preview, attribute: .Bottom, multiplier: 1, constant: rowPadding))
                
                backgroundScrollView.addConstraint(NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: backgroundScrollView, attribute: .Leading, multiplier: 1, constant: 0))
                
                backgroundScrollView.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: backgroundScrollView, attribute: .Width, multiplier: 1, constant: 0))
                
            }
            //如果设定了初始值，则高亮初始值cell
            if let selectedIndexes = delegate.initialSelectionIndex?(self) {
                for index in selectedIndexes {
                    let cell = selectionCells[index]
                    cell.selected = true
                }
            }
            
        }
    }
    
}
