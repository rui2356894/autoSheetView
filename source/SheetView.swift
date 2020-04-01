//
//  SheetView.swift
//  SheetviewDemo
//
//  Created by lanyee-ios2 on 2020/3/27.
//  Copyright © 2020 lanyee-ios2. All rights reserved.
//

import UIKit


//需要的手势
public struct GestureType: OptionSet {
    public init(rawValue:Int) {
        self.rawValue = rawValue
    }
    public var rawValue:Int
    static let tapGesture = GestureType(rawValue:1<<0)
    static let longPressGesture = GestureType(rawValue:1<<1)
}

public class SheetView: UIView,UICollectionViewDelegate, UICollectionViewDataSource ,UIScrollViewDelegate,SheetTouchEventDelegate {
    
    /// 数据源代理
    public weak var         dataSource:                       SheetViewDataSource?
    /// 代理
    public weak var         delegate:                         SheetViewDelegate?
    //数据源
    public  var             contentData:                       [Any]                    =  []
    //选中数据 原本此属性是字典类型:[T:Set] key是hash值 可以记录选中某单个item 现在直接记录是section
    private var             selectIndex:                         Int                     = -1
    //此版本 只支持单选
    public var              hasSupplementData:                  [Any]                   = []
    /// 屏幕数据
    public var              screenData:                         Set<Int>                = []
    /// item最小宽度
    public var              itemMinWidth:                       CGFloat                 = 50
    //记录滑动位置
    private var             scrollViewStartPosPoint:            CGPoint                 = CGPoint(x: 0, y: 0)
    //记录滑动方向
    private var             scrollDirection                                             = 0
    //是否自适应宽度
    public var              isAutoLayout:                       Bool                    = false
    //记录高亮的index
    public var              HighlightedIndex:                   Int                     = -1
    //item高度
    public var              itemHeight:                         CGFloat                 = 50
    //头部高度
    public var              headerViewHeight:                   CGFloat                 = 30
    //补充视图高度
    public var              supplementViewHeight:               CGFloat                 = 50
    /// 虚线颜色
    public  var             seperatorColor:                     UIColor                 = UIColor.lightGray
    //是否有弹性滑动
    public var bounces: Bool = false {
        didSet{
            self.collectionView.bounces = self.bounces
        }
    }
    //一行条目
    public  var rowCount: Int = 0 {
        didSet {
            self.collectionView.contentOffset.x = 0
        }
    }
    
    //冻结列数
    public var freezeColumn: Int = 1 {
        didSet {
            if self.freezeColumn > self.rowCount{
                self.freezeColumn = 0
            }
        }
    }
    /// 背景色设置
    public override var backgroundColor: UIColor? {
        didSet{
            self.collectionView.backgroundColor = self.backgroundColor
        }
    }
    
    //展现数据控件
    public lazy var collectionView : TouchEventCollectionView = {
        let collectionView:TouchEventCollectionView = TouchEventCollectionView.init(frame:self.bounds, collectionViewLayout: self.viewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.touchDelegagte = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.allowsMultipleSelection = true
        collectionView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        return collectionView
    }()
    
    //布局
    private lazy var viewLayout:SheetViewLayout = {
        let viewLayout:SheetViewLayout  = SheetViewLayout.init()
        viewLayout.sheetView = self
        return viewLayout
    }()
    
    //需要哪些手势
    public var needGstures: GestureType = []
    {
        didSet{
            guard let gestureRecognizers = self.collectionView.gestureRecognizers else { return }
            if self.needGstures.rawValue != 1 {
                if !gestureRecognizers.contains(longPress) {
                    collectionView.addGestureRecognizer(longPress)
                }
            }else{
                if gestureRecognizers.contains(longPress) {
                    collectionView.removeGestureRecognizer(longPress)
                }
            }
        }
    }
    //长按手势
    private lazy var longPress:UIGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress(gesture:)))
        longPress.minimumPressDuration = 1
        return longPress
    }()
    
    //长按手势识别
    @objc func cellLongPress(gesture:UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: self.collectionView)
            if self.needGstures.contains(.longPressGesture) {
                guard let delegate = self.delegate else {return}
                guard let indexPath = self.collectionView.indexPathForItem(at: point) else {return}
                if self.viewLayout.allItemsAttributes[indexPath.section].count == self.rowCount + 1 {
                    self.viewLayout.selectItem(indexPath: indexPath, collectionView: collectionView)
                }
                
                if delegate.sheetView(self, longPressHasSupplementForSectionAtData: self.contentData[indexPath.section - 1]){
                    self.viewLayout.selectItem(indexPath: indexPath, collectionView: collectionView)
                }
            }
        }
    }
    
    //返回需要订阅数据
    public var needSignMarket:[Any] {
        var data:[Any] = []
        guard self.contentData.count == 0 else {return []}
        for index in self.viewLayout.offsetYOfMaxSction..<self.viewLayout.numberOfMaxSection+self.viewLayout.offsetYOfMaxSction {
            if self.contentData.count > index {
                data.append(self.contentData[index])
            }
        }
        return data
    }
    
    //初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collectionView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        self.collectionView.frame = self.bounds
    }
    
    
    // MARK: - UICollectionViewDelegate or UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  self.rowCount != 0 ? self.contentData.count + 1 :0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let iscontains = self.viewLayout.supplementAttributes.filter { (supplmentItem) -> Bool in
            return supplmentItem.indexPath.section == section
        }
        /// 如果包含代表则返回列数+1,+1代表附属视图
        if iscontains.count > 0 {
            return self.rowCount + 1
        }
        return self.rowCount
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           guard let delegate = self.delegate,
                     indexPath.item != self.rowCount else {return}
           let isTap = self.needGstures.rawValue == 1
           if indexPath.section == 0 {
               collectionView.deselectItem(at: indexPath, animated: false)
               delegate.sheetView(self, didSelectItemAt: indexPath.item, headerForData:nil, isTapGesture: isTap)
           }else{
               let sectionData = self.contentData[indexPath.section - 1]
               if delegate.sheetView(self, tapHasSupplementForSectionAtData: sectionData) {
                // 需要附属视图
                   var indexitem = IndexSet.init()
                   for index in 0..<self.rowCount{
                       indexitem.update(with: index)
                       let indexPathCell = IndexPath(item: index, section: indexPath.section)
                       collectionView.selectItem(at: indexPathCell, animated: false,scrollPosition:[])
                   }
                self.hasSupplementData.append(sectionData)
                self.viewLayout.selectItem(indexPath: indexPath, collectionView: collectionView)
               }
            self.selectIndex = indexPath.section - 1
               delegate.sheetView(self, didSelectItemAt: indexPath.item, contentForData: sectionData, isTapGesture:isTap)
               
           }
       }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate,
            indexPath.item != self.rowCount else {return}
        let isTap = self.needGstures.rawValue == 1
        if indexPath.section == 0 {
            delegate.sheetView(self, didDeselectItemAt: indexPath.item, headerForData: nil, isTapGesture: isTap)
        }else{
            let sectionData = self.contentData[indexPath.section - 1]
            if delegate.sheetView(self, tapHasSupplementForSectionAtData: sectionData) {
                self.viewLayout.selectItem(indexPath: indexPath, collectionView: collectionView)
                for index in 0..<self.rowCount{
                    let indexPathCell = IndexPath(item: index, section: indexPath.section)
                    collectionView.deselectItem(at: indexPathCell, animated: false)
                }
                self.hasSupplementData.removeAll()
            }else{
                if indexPath.section - 1 == self.selectIndex {
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
            }
            self.selectIndex = -1
            delegate.sheetView(self, didDeselectItemAt: indexPath.item, contentForData: sectionData, isTapGesture:isTap)
            
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = self.dataSource else {
            assert(false, "未实现代理")
            return UICollectionViewCell.init()
        }
        if indexPath.section == 0 {
            // 返回头部
            let cell = dataSource.sheetView(self, cellForData: nil, headerForIndexAt: indexPath.item)
            if let c = cell as? SheetViewCell {
            c.sectiondata = nil
            return c
            }
            return cell
        }
        if  indexPath.item == self.rowCount {
            // 返回附属视图
            let cell =  dataSource.sheetView(self, cellForData:self.contentData[indexPath.section - 1], supplementViewForSectionAt: indexPath.section)
            return cell
        }
        let cell = dataSource.sheetView(self, cellForData: self.contentData[indexPath.section - 1], contentForIndexAt: indexPath.item)
        if indexPath.section == self.HighlightedIndex {
            cell.isHighlighted = true
        }else{
            cell.isHighlighted = false
        }
        if let c = cell as? SheetViewCell {
        c.sectiondata = self.contentData[indexPath.section - 1]
        return c
        }
        return cell
    }
    
    
    
    
    //MARK: - touch事件代理传递
    public func sheetViewTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self.collectionView),
            let indexPath = self.collectionView.indexPathForItem(at: point),
            let indexset = delegate?.sheetView(self, shouldHighlightForItemAt: indexPath.row, contentForData: self.contentData[indexPath.section - 1]),
            self.contentData.count > indexPath.section - 1,indexPath.section != 0 else {
                return
        }
        // 高亮section设置
        self.HighlightedIndex = indexPath.section
        for index  in indexset {
            // 获取cell
            if  let cell = self.collectionView.cellForItem(at:IndexPath(item: index, section: indexPath.section)) {
                cell.isHighlighted = true
            }
        }
    }
    
    public func sheetViewtouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self.collectionView),
            let indexPath = self.collectionView.indexPathForItem(at: point),
            self.contentData.count > indexPath.section - 1,indexPath.section != 0 else {
                return
        }
        // 取消所有屏幕内高亮
        self.HighlightedIndex = -1
        self.collectionView.visibleCells.forEach({$0.isHighlighted = false})
    }
    
    //MARK: - UIScrollViewDelegate
    //解决在45度水平和垂直滑动共存问题
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollDirection == 0 {
            if abs(self.scrollViewStartPosPoint.x - scrollView.contentOffset.x) < abs(self.scrollViewStartPosPoint.y - scrollView.contentOffset.y)
            {
                self.scrollDirection = 1
            }else{
                self.scrollDirection = 2
            }
        }
        if self.scrollDirection == 1 {
            scrollView.contentOffset = CGPoint(x: self.scrollViewStartPosPoint.x, y: scrollView.contentOffset.y)
        }
        else if self.scrollDirection == 2{
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: self.scrollViewStartPosPoint.y)
        }
        if let delegate = self.delegate  {
            delegate.sheetViewDidScroll(scrollView)
            
        }
        
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewStartPosPoint = scrollView.contentOffset
        self.scrollDirection = 0
        if let delegate = self.delegate  {
            delegate.sheetViewWillBeginDragging(scrollView)
            
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            self.scrollDirection = 0
        }
        if let delegate = self.delegate  {
            delegate.sheetViewDidEndDragging(scrollView, willDecelerate: decelerate)
            
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollDirection = 0
        if let delegate = self.delegate  {
            delegate.sheetViewDidEndDecelerating(scrollView)
            
        }
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let delegate = self.delegate  {
            delegate.sheetViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let delegate = self.delegate  {
            delegate.sheetViewWillBeginDecelerating(scrollView)
            
        }
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let delegate = self.delegate  {
            delegate.sheetViewDidEndScrollingAnimation(scrollView)
            
        }
    }
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let delegate = self.delegate  {
            return delegate.sheetViewShouldScrollToTop(scrollView)
            
        }
        return true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if let delegate = self.delegate  {
            delegate.sheetViewDidScrollToTop(scrollView)
            
        }
    }
    
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        if let delegate = self.delegate  {
            if #available(iOS 11.0, *) {
                delegate.sheetViewDidChangeAdjustedContentInset(scrollView)
            }
        }
    }
}
