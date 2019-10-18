//
//  DataViewModelDelegate.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation
/**
 - 约束视图模型类实现，暴露CoreData Entity相关属性及组装视图模型对象
 */
protocol DataViewModelDelegate {
    /// 视图模型必须具有id属性
    var id: UUID {get}
    /// 视图模型对应的CoreData Entity的名称
    static var entityName:String {get}
    /// CoreData Entity属性与对应的视图模型对象的属性集合
    ///
    /// - returns：key是CoreData Entity的各个属性的名称，Any是对应的值
    func entityPairs() -> Dictionary<String,Any?>
    /// 根据查询结果组装视图模型对象
    ///
    /// - parameter result：fetch方法查询结果
    func packageSelf(result:NSFetchRequestResult)
}



