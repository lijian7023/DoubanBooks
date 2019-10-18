//
//  CategoryRepositoy.swift
//  DoubaiBooks
//
//  Created by Kirin on 2019/10/12.
//  Copyright © 2019 Kirin. All rights reserved.
//
import CoreData
import Foundation

class CategoryRepositoy {
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm: VMCategory) {
        let description = NSEntityDescription.entity(forEntityName: VMCategory.entityName, in: context)
        let vMCategory = NSManagedObject(entity: description!, insertInto: context)
        vMCategory.setValue(vm.id, forKey: VMCategory.colId)
        vMCategory.setValue(vm.name, forKey: VMCategory.colName)
        vMCategory.setValue(vm.image, forKey: VMCategory.colImage)
        app.saveContext()
    }
    
    func get() throws -> [VMCategory] {
        var vMCategorys = [VMCategory]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        do {
            let result = try context.fetch(fetch) as! [VMCategory]
            for item in result {
                let vm = VMCategory()
                vm.id = item.id
                vm.name = item.name
                vm.image = item.image
                vMCategorys.append(vm)
                
            }
        } catch {
            throw DataError.readCollestionError("读取集合数据失败")
        }
        return vMCategorys
    }
    
    func getByKeyword(keyword: String? = nil) throws -> [VMCategory] {
        var vMCategorys = [VMCategory]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        do {
            let result = try context.fetch(fetch) as! [VMCategory]
            if let kw = keyword {
                fetch.predicate = NSPredicate(format: "name like[c] %@ || id like[c] %@", "*\(kw)*","*\(kw)*")
            }
            for item in result {
                let vm = VMCategory()
                vm.id = item.id
                vm.name = item.name
                vm.image = item.image
                vMCategorys.append(vm)
                
            }
        } catch {
            throw DataError.readCollestionError("读取集合数据失败")
        }
        
        return vMCategorys
    }
    
    func delete(id: UUID) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch) as! [Category]
            let bookRepositoy = BookRepositoy(app)
            for m in result {
                let books = try bookRepositoy.getBookByCategoryId(m.id!)
                for b in books {
                    try bookRepositoy.delete(id: b.id)
                }
                context.delete(m)
            }
            app.saveContext()
        } catch {
            throw DataError.entityExistsError("获取数据失败")
        }
    }
    
    func update(_ vMCategory:VMCategory) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vMCategory.id.uuidString)
        do {
            let result = try context.fetch(fetch) as! [Category]
            for m in result {
                m.setValue(vMCategory.name, forKey: VMCategory.colName)
                m.setValue(vMCategory.image, forKey: VMCategory.colImage)
                app.saveContext()
            }
            app.saveContext()
        } catch {
            throw DataError.entityExistsError("获取数据失败")
        }
    }
    
    func isExists(_ byName:String) throws -> Bool {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "\(VMCategory.colName) = %@", byName)
        do {
            let result = try context.fetch(fetch) as! [Category]
            return result.count>0
        } catch  {
            throw DataError.entityExistsError("判断数据失败")
        }
    }
}

