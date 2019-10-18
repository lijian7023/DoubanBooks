//
//  BookRepositoy.swift
//  DoubaiBooks
//
//  Created by Kirin on 2019/10/12.
//  Copyright © 2019 Kirin. All rights reserved.
//
import CoreData
import Foundation

class BookRepositoy {
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm: VMBook) {
        let description = NSEntityDescription.entity(forEntityName: VMBook.entityName, in: context)
        let vMBook = NSManagedObject(entity: description!, insertInto: context)
        vMBook.setValue(vm.id, forKey: VMBook.colId)
        vMBook.setValue(vm.author, forKey: VMBook.colAuthor)
        vMBook.setValue(vm.binding, forKey: VMBook.colBinding)
        vMBook.setValue(vm.image, forKey: VMBook.colImage)
        vMBook.setValue(vm.authorIntro, forKey: VMBook.colAuthorIntro)
        vMBook.setValue(vm.categoryId, forKey: VMBook.colCategoryId)
        vMBook.setValue(vm.isbn10, forKey: VMBook.colIsbn10)
        vMBook.setValue(vm.isbn13, forKey: VMBook.colIsbn13)
        vMBook.setValue(vm.pages, forKey: VMBook.colPages)
        vMBook.setValue(vm.price, forKey: VMBook.colPrice)
        vMBook.setValue(vm.pubdate, forKey: VMBook.colPubdate)
        vMBook.setValue(vm.publisher, forKey: VMBook.colPublisher)
        vMBook.setValue(vm.summary, forKey: VMBook.colSummary)
        vMBook.setValue(vm.title, forKey: VMBook.colTitle)
        app.saveContext()
    }
    
    func get() throws -> [VMBook] {
        var vMBooks = [VMBook]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        let result = try context.fetch(fetch) as! [VMBook]
        for item in result {
            let vm = VMBook()
            vm.id = item.id
            vm.categoryId = item.categoryId
            vm.image = item.image
            vm.author = item.author
            vm.authorIntro = item.authorIntro
            vm.binding = item.binding
            vm.isbn10 = item.isbn10
            vm.isbn13 = item.isbn13
            vm.pages = item.pages
            vm.price = item.price
            vm.pubdate = item.pubdate
            vm.publisher = item.publisher
            vm.summary = item.summary
            vm.title = item.title
            vMBooks.append(vm)
            
        }
        return vMBooks
    }
    
    func getByKeyword(keyword format:String,args:[Any]) throws -> [VMBook] {
        var vMBooks = [VMBook]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        
        //fetch.predicate = NSPredicate(format: "\(VMBook.colTitle) like[c] %@ || \(VMBook.colId) like[c] %@", "*\(kw)*","*\(kw)*")
        fetch.predicate = NSPredicate(format: format, args)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            for item in result {
                let vm = VMBook()
                vm.id = item.id
                vm.categoryId = item.categoryId
                vm.image = item.image
                vm.author = item.author
                vm.authorIntro = item.authorIntro
                vm.binding = item.binding
                vm.isbn10 = item.isbn10
                vm.isbn13 = item.isbn13
                vm.pages = item.pages
                vm.price = item.price
                vm.pubdate = item.pubdate
                vm.publisher = item.publisher
                vm.summary = item.summary
                vm.title = item.title
                vMBooks.append(vm)
            }
            return vMBooks
        } catch {
            throw DataError.readCollestionError("读取集合数据失败")
        }
    }
    
    func getBookByCategoryId(_ categoryId: UUID) throws -> [VMBook] {
        var vMBooks = [VMBook]()
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            fetch.predicate = NSPredicate(format: "\(VMBook.colCategoryId) = %@", "*\(categoryId.uuidString)*")
            
            for item in result {
                let vm = VMBook()
                vm.id = item.id
                vm.categoryId = item.categoryId
                vm.image = item.image
                vm.author = item.author
                vm.authorIntro = item.authorIntro
                vm.binding = item.binding
                vm.isbn10 = item.isbn10
                vm.isbn13 = item.isbn13
                vm.pages = item.pages
                vm.price = item.price
                vm.pubdate = item.pubdate
                vm.publisher = item.publisher
                vm.summary = item.summary
                vm.title = item.title
                vMBooks.append(vm)
                
            }
        } catch {
            throw DataError.readCollestionError("读取集合数据失败")
        }
        
        return vMBooks
    }
    
    func delete(id: UUID) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colId) = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            for m in result {
                context.delete(m as! NSManagedObject)
            }
            app.saveContext()
        } catch  {
            throw DataError.readCollestionError("删除图书失败")
        }
        
    }
    
    func update(_ vMBook:VMBook) throws {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colId) = %@", vMBook.id.uuidString)
        do {
            let m = try context.fetch(fetch)[0] as! NSManagedObject
            m.setValue(vMBook.author, forKey: VMBook.colAuthor)
            m.setValue(vMBook.binding, forKey: VMBook.colBinding)
            m.setValue(vMBook.image, forKey: VMBook.colImage)
            m.setValue(vMBook.authorIntro, forKey: VMBook.colAuthorIntro)
            m.setValue(vMBook.categoryId, forKey: VMBook.colCategoryId)
            m.setValue(vMBook.isbn10, forKey: VMBook.colIsbn10)
            m.setValue(vMBook.isbn13, forKey: VMBook.colIsbn13)
            m.setValue(vMBook.pages, forKey: VMBook.colPages)
            m.setValue(vMBook.price, forKey: VMBook.colPrice)
            m.setValue(vMBook.pubdate, forKey: VMBook.colPubdate)
            m.setValue(vMBook.publisher, forKey: VMBook.colPublisher)
            m.setValue(vMBook.summary, forKey: VMBook.colSummary)
            m.setValue(vMBook.title, forKey: VMBook.colTitle)
            app.saveContext()
        } catch {
            throw DataError.readCollestionError("更新图书失败")
        }
        
    }
    
    func isExists(_ vmBook:VMBook) throws -> Bool {
        //选择表
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colIsbn10) = %@ || \(VMBook.colIsbn13) = %@", vmBook.isbn10!,vmBook.isbn13!)
        do {
            let result = try context.fetch(fetch) as! [Book]
            return result.count>0
        } catch  {
            throw DataError.entityExistsError("判断数据失败")
        }
        
    }
}

