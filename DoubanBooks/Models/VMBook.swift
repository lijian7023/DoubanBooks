//
//  ViewBook.swift
//  DoubaiBooks
//
//  Created by Kirin on 2019/10/12.
//  Copyright © 2019 Kirin. All rights reserved.
//

import CoreData
import Foundation
class VMBook:NSObject,DataViewModelDelegate{
    
    var id:UUID
    var categoryId:UUID?
    var author:String?
    var pubdate:String?
    var image:String?
    var pages:Int32?
    var publisher:String?
    var isbn10:String?
    var isbn13:String?
    var title:String?
    var authorIntro:String?
    var summary:String?
    var price:String?
    var binding: String?
    
    static let entityName = "Book"
    static let colId = "id"
    static let colBinding = "binding"
    static let colCategoryId = "categoryId"
    static let colAuthor = "author"
    static let colPubdate = "pubdate"
    static let colImage = "image"
    static let colPages = "pages"
    static let colPublisher = "publisher"
    static let colIsbn10 = "isbn10"
    static let colIsbn13 = "isbn13"
    static let colTitle = "title"
    static let colAuthorIntro = "authorIntro"
    static let colSummary = "summary"
    static let colPrice = "price"
    
    override init() {
        self.id=UUID()
    }
    
    func entityPairs() -> Dictionary<String, Any?> {
        var dict:[String:Any?] = [:]
        dict[VMBook.colId] = id
        dict[VMBook.colCategoryId] = categoryId
        dict[VMBook.colBinding] = binding
        dict[VMBook.colAuthor] = author
        dict[VMBook.colPubdate] = pubdate
        dict[VMBook.colImage] = image
        dict[VMBook.colPages] = pages
        dict[VMBook.colPublisher] = publisher
        dict[VMBook.colIsbn10] = isbn10
        dict[VMBook.colIsbn13] = isbn13
        dict[VMBook.colTitle] = title
        dict[VMBook.colAuthorIntro] = authorIntro
        dict[VMBook.colSummary] = summary
        dict[VMBook.colPrice] = price
        return dict
    }
    
    func packageSelf(result: NSFetchRequestResult) {
        let book = result as! Book
        id = book.id!
        categoryId = book.categoryId
        binding = book.binding
        author = book.author
        pubdate = book.pubdate
        image = book.image
        pages = book.pages
        publisher = book.publisher
        isbn10 = book.isbn10
        isbn13 = book.isbn13
        title = book.title
        authorIntro = book.authorIntro
        summary = book.summary
        price = book.price
    }
}



