//
//  BookFactory.swift
//  DoubaiBooks
//
//  Created by Kirin on 2019/10/14.
//  Copyright © 2019 Kirin. All rights reserved.
//

import CoreData
import Foundation
final class BookFactory {
    var repository:Repository<VMBook>
    private static var instance: BookFactory?
    
    
    private init(_ app: AppDelegate) {
        repository = Repository<VMBook>(app)
        
    }
    
    static func getInstance(_ app: AppDelegate) -> BookFactory{
        if let obj = instance {
            return obj
        }else{
            let token = "info.lzzy.factory.book"
            DispatchQueue.once(token: token,block: {
                if instance == nil{
                    instance = BookFactory(app)
                }
            })
            return instance!
        }
        
    }
    
    func getBooksOf(category id:UUID)throws -> [VMBook] {
            return try
                repository.getExplicitlyBy([VMBook.colCategoryId],keyword:id.uuidString)
    }
    
    func getBookBy(id:UUID) throws -> VMBook? {
        let books = try repository.getExplicitlyBy([VMBook.colId],
            keyword:id.uuidString)
        if books.count > 0 {
            return books[0]
        }
        return nil
    }
    
    func isBookExists(book:VMBook) throws -> Bool {
        var match10 = false
        var match13 = false
        if let isbn10 = book.isbn10 {
            if isbn10.count > 0{
                match10 = try
                    repository.isEntityExists([VMBook.colIsbn10],
                    keyword:isbn10)
            }
        }
        if let isbn13 = book.isbn13 {
            if isbn13.count > 0{
                match13 = try
                    repository.isEntityExists([VMBook.colIsbn13],
                    keyword:isbn13)
            }
        }
        return match13 || match10
    }
    
    func searchBooks(keyword:String)throws -> [VMBook] {
       let cols = [VMBook.colIsbn13,VMBook.colTitle,VMBook.colAuthor,VMBook.colPublisher,
            VMBook.colSummary]
        let books = try repository.getBy(cols,keyword:keyword)
        return books
    }
    
    func add(book: VMBook) -> (Bool,String?) {
         do {
            if try isBookExists(book: book) {
               return (false,"图书已存在")
            }
            repository.insert(vm: book)
            return (true,nil)
          } catch DataError.entityExistsError(let info) {
             return (false,info)
          } catch {
             return (false,error.localizedDescription)
          }
    }
    
    func removeBook(id:UUID) -> (Bool,String? ){
        do {
            try repository.delete(id: id)
            return (true,nil)
        } catch DataError.deleteEntityError(let info) {
            return (false,info)
        } catch {
            return (false,error.localizedDescription)
        }
    }
    
    
    
//    func getAllBooks() throws ->[VMBook] {
//        return try repository.get()
//    }
//
//    func addBook(vmBook: VMBook) -> (Bool,String?) {
//        do {
//            if try repository.isExists(vmBook) {
//                return (false,"该书已经添加")
//            }
//            repository.insert(vm: vmBook)
//            return (true,nil)
//        } catch DataError.entityExistsError(let info) {
//            return (false,info)
//        } catch {
//            return (false,error.localizedDescription)
//        }
//    }
//
//    func deleteBook(vmBook: VMBook) -> (Bool,String?) {
//        do {
//            if try repository.isExists(vmBook) {
//                try repository.delete(id: vmBook.id)
//                return (true,nil)
//            }else{
//                return (false,"不存在该图书")
//            }
//        } catch DataError.entityExistsError(let info) {
//            return (false,info)
//        } catch {
//            return (false,error.localizedDescription)
//        }
//    }
//
//    func getByKeyword(keyword: String) -> (Bool,[VMBook]?,String?) {
//        do {
//            let books = try repository.getByKeyword(keyword: "\(VMBook.colTitle) like[c] %@ || \(VMBook.colId) like[c] %@", args: [keyword,keyword] )
//            return (true,books,nil)
//        } catch DataError.readCollestionError(let info) {
//            return (false,nil,info)
//        } catch {
//            return (false,nil,error.localizedDescription)
//        }
//    }
//
//    func updateBooks(_ vmBook:VMBook) -> (Bool,String?) {
//        do {
//            try repository.update(vmBook)
//            return (true,nil)
//        } catch DataError.readCollestionError(let info) {
//            return (false,info)
//        } catch {
//            return (false,error.localizedDescription)
//        }
//    }
}




