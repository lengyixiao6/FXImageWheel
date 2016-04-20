//
//  FXWheelView.swift
//  FXImageWheel
//
//  Created by Benniu15 on 16/4/19.
//  Copyright © 2016年 Wind. All rights reserved.
//

import UIKit

//循环类型
enum cycleStyleMode{
    
    case  InfiniteCirculant //无限轮播
    case  RoundCirculant    //往返循环
}
//定时器时间
let timeN:NSTimeInterval = 1

/**
 *  选择点击了某个imageView的代理协议
 */
protocol FXWheelViewDelegate:NSObjectProtocol {
    
    func choseImageIndex(index:Int)
}

class FXWheelView: UIView {

    weak var delegate:FXWheelViewDelegate?
    var titleArray:[String]?{
        
        didSet{
            
            let width  = self.frame.size.width
            self.addSubview(titleBgView)
            titleBgView.addSubview(titleLabel)
            titleLabel.text = titleArray![0] as String
            pageControl.frame = CGRectMake(width*0.5, self.frame.size.height-50,width*0.5,20)
        }
    }
    private var dataArr:[String]?
    private var cycleMd:cycleStyleMode?
    private var timer:NSTimer!
    
    init(frame: CGRect, dataArray:[String], cycleMode:cycleStyleMode) {
        
        super.init(frame: frame)
        dataArr = dataArray
        cycleMd = cycleMode
        
        //添加ScrollView
        let width  = frame.size.width
        let height = frame.size.height
        bgScrollView.contentSize = CGSizeMake(width*CGFloat(dataArray.count), height)
        if (cycleMode == cycleStyleMode.InfiniteCirculant && dataArray.count > 0) {
            
            bgScrollView.contentSize = CGSizeMake(width*CGFloat(dataArray.count+2), height)
            bgScrollView.setContentOffset(CGPointMake(width, 0), animated: false)
        }
        addSubview(bgScrollView)

        //添加页码
        pageControl.numberOfPages = dataArray.count;
        addSubview(pageControl)
        
        //添加滚动图片
        addImage(dataArray)
        
        //添加定时器
        addTimer()
    }
    
    /**
     添加滚动图片
    */
    private func addImage(dataArray:[String]) {
        
        let width  = bgScrollView.frame.size.width
        let height = bgScrollView.frame.size.height
        let count = cycleMd == cycleStyleMode.RoundCirculant ? dataArray.count:dataArray.count+2
        
        if (cycleMd == cycleStyleMode.InfiniteCirculant) {
            
            for i in 0..<count {
                
                let imgeView = UIImageView(frame:CGRectMake(CGFloat(i)*width, 0, width, height))
                imgeView.tag = -100 + i
                imgeView.userInteractionEnabled = true
                if (i == 0) {
                    
                    imgeView.image = UIImage(named:dataArray[count-3] as String)
                }
                else if (i == count - 1){
                    
                    imgeView.image = UIImage(named:dataArray[0] as String)
                }
                else{
                    
                    imgeView.image = UIImage(named:dataArray[i-1] as String)
                }
                bgScrollView.addSubview(imgeView)
                
                //添加手势
                let tap = UITapGestureRecognizer(target:self, action: "imageTapGesture:")
                imgeView.addGestureRecognizer(tap)
                
            }
        }else{
            
            for i in 0..<count {
                
                let imgeView = UIImageView(frame:CGRectMake(CGFloat(i)*width, 0, width, height))
                imgeView.image = UIImage(named:dataArray[i] as String)
                imgeView.tag = -100 + i
                imgeView.userInteractionEnabled = true
                bgScrollView.addSubview(imgeView)
                
                //添加手势
                let tap = UITapGestureRecognizer(target:self, action: "imageTapGesture:")
                imgeView.addGestureRecognizer(tap)
            }
        }
    }
    //手势点击执行方法
    func imageTapGesture(tap:UITapGestureRecognizer) {
        
        delegate?.choseImageIndex(100 + (tap.view?.tag)!)
    }
    
    /**
     添加定时器
     */
    func addTimer() {
            
        timer = NSTimer.scheduledTimerWithTimeInterval(timeN, target: self, selector: "ScrollImageWheel", userInfo:nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    //关闭定时器
    func closeTimer() {
        
        if timer != nil {
            
            timer.invalidate()
        }
    }
    /**
     定时器执行方法
     */
    var isInLine:Bool = true
    func ScrollImageWheel() {
        
        let width  = bgScrollView.frame.size.width
        var p = bgScrollView.contentOffset
        
        if cycleMd == cycleStyleMode.RoundCirculant {
            
            if isInLine {
                
                p.x += width
                bgScrollView.setContentOffset(CGPointMake(p.x, p.y), animated: true)
                if Int(p.x/width) >= dataArr!.count-1 {
                    
                    isInLine = false
                }
            }
            else{
                
                p.x -= width
                bgScrollView.setContentOffset(CGPointMake(p.x, p.y), animated: true)
                if Int(p.x/width) <= 0 {
                    
                    isInLine = true
                }
            }
        }
        else{
            
            p.x += width
            bgScrollView.setContentOffset(CGPointMake(p.x, p.y), animated: true)
        }
    }
    
    /// 背景ScrollView
    private lazy var bgScrollView:UIScrollView = {
        
        let bgScrollView = UIScrollView(frame: self.bounds)
        bgScrollView.contentOffset = CGPointMake(0, 0)
        bgScrollView.delegate = self
        bgScrollView.showsHorizontalScrollIndicator = false;
        bgScrollView.showsVerticalScrollIndicator = false;
        bgScrollView.bounces = false;
        bgScrollView.pagingEnabled = true;
        
        return bgScrollView
    }()
    /// 显示所在页pageControl
    private lazy var pageControl:UIPageControl = {
        
        let width  = self.frame.size.width
        let pageControl = UIPageControl(frame: CGRectMake(width*0.25, self.frame.size.height-30,width*0.5,20))
        pageControl.currentPage = 0;
        pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        pageControl.hidesForSinglePage = true
        
        return pageControl
    }()
    /// 显示的文字标题
    private lazy var titleLabel:UILabel = {
        
        let titleLab = UILabel(frame: CGRectMake(10, 0,self.frame.size.width-20,30))
        titleLab.textColor = UIColor.whiteColor()
        titleLab.font = UIFont.systemFontOfSize(14)
        
        return titleLab
    }()
    /// 显示的文字背景
    private lazy var titleBgView:UIView = {
        
        let titleBgView = UILabel(frame: CGRectMake(0, self.frame.size.height-30,self.frame.size.width,30))
        titleBgView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        
        return titleBgView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIScrollViewDelegate代理
extension FXWheelView:UIScrollViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let pNum:Int = Int(scrollView.contentOffset.x/frame.size.width)
        let width    = frame.size.width
        if (cycleMd == cycleStyleMode.RoundCirculant) {
            
            pageControl.currentPage = pNum
            if (titleArray != nil  && pNum < titleArray?.count && pNum >= 0) {
                
                titleLabel.text = titleArray![pNum] as String
            }
        }
        else {

            pageControl.currentPage = pNum-1
            if pNum == dataArr!.count+1 {
                
                pageControl.currentPage = 0
                bgScrollView.setContentOffset(CGPointMake(width, 0), animated: false)
                if (titleArray != nil) {
                    
                    titleLabel.text = titleArray!.first!
                }
            }
            if (titleArray != nil && pNum < titleArray!.count+1 && pNum > 0) {
                
                titleLabel.text = titleArray![pNum-1] as String
            }
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pNum:Int = Int(scrollView.contentOffset.x/frame.size.width)
        let width    = frame.size.width
        if (cycleMd == cycleStyleMode.RoundCirculant) {
            
            if pNum >= dataArr!.count-1 {
                
                isInLine = false
            }
            else if pNum <= 0 {
                
                isInLine = true
            }
        }
        else{
            
            pageControl.currentPage = pNum-1
            if pNum == dataArr!.count+1 {
                
                pageControl.currentPage = 0
                bgScrollView.setContentOffset(CGPointMake(width, 0), animated: false)
                if (titleArray != nil) {
                    
                    titleLabel.text = titleArray!.last!
                }
            }
            else if pNum == 0 {
                
                pageControl.currentPage = dataArr!.count
                bgScrollView.setContentOffset(CGPointMake(CGFloat(dataArr!.count
                    )*width, 0), animated: false)
                if (titleArray != nil) {
                    
                    titleLabel.text = titleArray!.first!
                }
            }
            if (titleArray != nil && pNum < titleArray!.count+1 && pNum > 0) {
                
                titleLabel.text = titleArray![pNum-1] as String
            }
            else if (titleArray != nil && pNum == 0 ) {
                
                titleLabel.text = titleArray!.last!
            }
        }
        
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        //关闭定时器
        closeTimer()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //添加定时器
        addTimer()
    }
}




