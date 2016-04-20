//
//  ViewController.swift
//  FXImageWheel
//
//  Created by Benniu15 on 16/4/19.
//  Copyright © 2016年 Wind. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FXWheelViewDelegate {

    var wheelView:FXWheelView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        
        let imgArr = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg"]
        let titleArr = ["1.爱对方家里看见对方","2.风格IE如果IPO供热颇高","3.杜尔爱国我热过非的故事","4.个我偶尔欧冠我偶偶啊搜到过","5.分公司的分公司答复","6.大发送到发送到发送到","7.剪短发了空间的算了可赶紧来开发的世界"]
        
        wheelView = FXWheelView(frame: CGRectMake(0,20,view.frame.size.width,250), dataArray:imgArr ,cycleMode:cycleStyleMode.InfiniteCirculant)
        wheelView!.delegate   = self;
        wheelView?.titleArray = titleArr
        view.addSubview(wheelView!)
    }

    func choseImageIndex(index: Int) {
        
        print("点击了：第\(index) 个图片")
    }
    
}

