//
//  SheetProtocol.swift
//  SheetView_Demo
//
//  Created by lanyee-ios2 on 2020/3/31.
//  Copyright © 2020 lanyee-ios2. All rights reserved.
//

import UIKit

//控件数据源代理
public protocol SheetViewDataSource: NSObjectProtocol {
    
    
    /// 返回内容数据cell
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - data: 内容数据
    ///   - index: 索引
    func  sheetView(_ sheetView: SheetView, cellForData data: Any, contentForIndexAt index: Int) -> UICollectionViewCell
    
    /// 返回头部cell
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - data: 数据
    ///   - index: 索引
    func  sheetView(_ sheetView: SheetView, cellForData data: Any?, headerForIndexAt index:Int) -> UICollectionViewCell
    
    /// 返回补充视图cell
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - data: 数据
    ///   - index: 索引
    func  sheetView(_ sheetView: SheetView, cellForData data: Any?, supplementViewForSectionAt section:Int) -> UICollectionViewCell
}

///控件代理
public protocol SheetViewDelegate: NSObjectProtocol {
    
    /// 长按是否有附属视图
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - data: 选中的数据
    func sheetView(_ sheetView: SheetView, longPressHasSupplementForSectionAtData data: Any) -> Bool
    
    /// 点击是否有附属视图
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - data: 选中的数据
    func sheetView(_ sheetView: SheetView, tapHasSupplementForSectionAtData data: Any) -> Bool
    
    /// 选中数据内容了某个item
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - index: 当前section中具体那个item
    ///   - data: 选中的数据
    ///   - isTapGesture: 是否是点击手势触发的
    func sheetView(_ sheetView: SheetView, didSelectItemAt index :Int ,contentForData data:Any, isTapGesture:Bool)
    
    /// 取消选中内容数据某个item
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - index: 当前section中具体那个item
    ///   - data: 选中的数据
    ///   - isTapGesture: 是否是点击手势触发的
    func sheetView(_ sheetView: SheetView, didDeselectItemAt index :Int ,contentForData data:Any, isTapGesture:Bool)
    
    /// 选中头部某个item
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - index:当前section中具体那个item
    ///   - data: 选中的数据
    ///   - isTapGesture: 是否是点击手势触发的
    func sheetView(_ sheetView: SheetView, didSelectItemAt index :Int ,headerForData data:Any? , isTapGesture:Bool)
    
    /// 取消选中头部某个item
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - index:当前section中具体那个item
    ///   - data: 选中的数据
    ///   - isTapGesture: 是否是点击手势触发的
    func sheetView(_ sheetView: SheetView, didDeselectItemAt index :Int ,headerForData data:Any? , isTapGesture:Bool)
    
    
    /// 需要高亮头部的集合
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - index: 点击的 索引
    ///   - data: 当前数据(为空)
    func sheetView(_ sheetView: SheetView, shouldHighlightForItemAt index:Int, headerForData data:Any?) -> IndexSet
    
    /// 需要高亮内容数据的集合
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - index: 点击的 索引
    ///   - data: 选中数据
    func sheetView(_ sheetView: SheetView, shouldHighlightForItemAt index:Int, contentForData data:Any) -> IndexSet
    
    /// 将要出现头部的数据
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - section: 第几行
    ///   - data: 数据
    ///   - index: 第几列
    func sheetView(_ sheetView: SheetView, willDisplay section: Int, cellForData data: Any?, headerforIndex index: Int)
    
    /// 消失的头部数据
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - section: 第几行
    ///   - data: 数据
    ///   - index: 第几列
    func sheetView(_ sheetView: SheetView, didEndDisplaying section: Int, cellForData data: Any?, headerforIndex index: Int)
    
    /// 将要出现补充的数据
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - section: 第几行
    ///   - data: 数据
    ///   - index: 第几列
    func sheetView(_ sheetView: SheetView, willDisplay section: Int, cellForData data: Any?, supplementViewForSection section: Int)
    
    /// 消失补充的数据
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - section: 第几行
    ///   - data: 数据
    ///   - index: 第几列
    func sheetView(_ sheetView: SheetView, didEndDisplaying section: Int, cellForData data: Any?, supplementViewForSection section: Int)
    
    /// 将要出现内容数据
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - section: 第几行
    ///   - data: 数据
    ///   - index: 第几列
    func sheetView(_ sheetView: SheetView, willDisplay section: Int, cellForData data: Any, contentForIndex index: Int)
    
    /// 消失内容数据
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - section: 第几行
    ///   - data: 数据
    ///   - index: 第几列
    func sheetView(_ sheetView: SheetView, didEndDisplaying section: Int, cellForData data: Any?, contentForIndex index: Int)
    
    /// 补充视图出现和消失
    /// - Parameters:
    ///   - sheetView: 控件
    ///   - isAddSupplement: 出现或消失
    ///   - indexPath: 索引
    func sheetView(_ sheetView:SheetView ,isAddSupplement:Bool,at indexPath:IndexPath)
    
    
    /// 滑动时候触发
    /// - Parameter scrollView: 滑动控件
    func sheetViewDidScroll(_ scrollView: UIScrollView)
    
    /// 用户开始拖动 scroll view 的时候被调用。
    /// - Parameter scrollView: 滑动控件
    func sheetViewWillBeginDragging(_ scrollView: UIScrollView)
    
    /// 将要结束拖动后被调用 scroll view 的时候被调用。
    /// - Parameter scrollView: 滑动控件
    func sheetViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
    /// 结束拖动后被调用 scroll view 的时候被调用。
    /// - Parameter scrollView: 滑动控件
    func sheetViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    /// 减速动画开始前被调用
    /// - Parameter scrollView: 滑动控件
    func sheetViewWillBeginDecelerating(_ scrollView: UIScrollView)
    
    /// 减速动画结束时被调用
    /// - Parameter scrollView: 滑动控件
    func sheetViewDidEndDecelerating(_ scrollView: UIScrollView)
    
    
    /// 滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
    /// - Parameter scrollView: 滑动控件
    func sheetViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    
    
    /// 点击状态栏是否回到顶部
    /// - Parameter scrollView: 滑动控件
    func sheetViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    
    func sheetViewDidScrollToTop(_ scrollView: UIScrollView)
    
    func sheetViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
    
}
