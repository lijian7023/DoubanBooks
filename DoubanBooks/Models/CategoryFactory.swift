//
//  CategoryFactory.swift
//  DoubaiBooks
//
//  Created by Kirin on 2019/10/14.
//  Copyright © 2019 Kirin. All rights reserved.
//
import CoreData
import Foundation
final class CategoryFactory {
    var repository:Repository<VMCategory>
    var app: AppDelegate?
    
    private static var instance: CategoryFactory?
    
    private init(_ app: AppDelegate) {
        repository = Repository<VMCategory>.init(app)
        self.app = app
    }
    
    static func getInstance(_ app: AppDelegate) -> CategoryFactory{
        if let obj = instance {
            return obj
        }else{
            let token = "info.lzzy.factory.category"
            DispatchQueue.once(token: token,block: {
                if instance == nil{
                    instance = CategoryFactory(app)
                }
            })
        }
        return CategoryFactory(app)
    }
    
    func getAllCategorys() throws ->[VMCategory] {
        return try repository.get()
    }
    
    func addCategory(category: VMCategory) -> (Bool,String?) {
        do {
            if try repository.isEntityExists([VMCategory.colName], keyword: category.name!) {
                return (false,"同样的类别已经存在")
            }
            repository.insert(vm: category)
            return (true,nil)
        } catch DataError.entityExistsError(let info) {
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
    
    func deleteCategory(category: VMCategory) -> (Bool,String?) {
        do {
            if try repository.isEntityExists([VMCategory.colName], keyword: category.name!) {
                try repository.delete(id: category.id)
                return (true,nil)
            }else{
                return (false,"不存在该类别")
            }
        } catch DataError.entityExistsError(let info) {
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
    
    func getByKeyword(cols: [String],keyword: String) -> (Bool,[VMCategory]?,String?) {
        do {
            let categorys = try repository.getBy(cols,keyword: keyword)
            return (true,categorys,nil)
        } catch DataError.readCollestionError(let info) {
            return (false,nil,info)
        } catch {
            return (false,nil,error.localizedDescription)
        }
    }
    
    func updateCategorys(_ vMCategory:VMCategory) -> (Bool,String?) {
        do {
            try repository.update(vm: vMCategory)
            return (true,nil)
        } catch DataError.readCollestionError(let info) {
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
    
    func getBookCountOfCategory(category id:UUID) -> Int? {
        do{
            return try
                BookFactory.getInstance(app!).getBooksOf(category: id).count
        }catch{
            return nil
            
        }
    }
    
    
    
    
    func remove(category: VMCategory) -> (Bool,String?) {
        if let count = getBookCountOfCategory(category: category.id){
            if count > 0 {
                return (false,"存在该类别图书，不能删除")
            }
            
        }else{
            return (false,"无法获取类别信息")
        }
        do{
            
            try repository.delete(id: category.id)
            return(true,nil)
        }catch DataError.deleteEntityError(let info){
            return(false,info)
            
        }catch{
            return (false,error.localizedDescription)
        }
    }}

extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}


