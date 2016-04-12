//
//  ViewController.swift
//  SelectionExample
//
//  Created by liu ting on 16/4/11.
//  Copyright © 2016年 liu ting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var selectionView: LTSelectionView!
    
    var selectionTitle = "你对此项目的看法"
    var selectionOptions = ["立项","pass"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionView.delegate = self
        selectionView.isMultiSelection = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 35/255, green: 195/255, blue: 131/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

//MARK: LTSelectionViewDelegate
extension ViewController: LTSelectionViewDelegate {
    func numberOfRowsForSelectionView(selectionView: LTSelectionView) -> Int {
        return selectionOptions.count
    }
    
    func optionTitleForRowAtIndex(selectionView: LTSelectionView, index: Int) -> String {
        return selectionOptions[index]
    }
    func selectionHeaderTitle(selectionView: LTSelectionView) -> String {
        return selectionTitle
    }
    
    func initialSelectionIndex(selectionView: LTSelectionView) -> [Int] {
        return [0]
    }
    
    func didSelectedRowAtIndex(selectionView: LTSelectionView, index:Int){
        print("did selected \(selectionOptions[index])")
    }

    
}

