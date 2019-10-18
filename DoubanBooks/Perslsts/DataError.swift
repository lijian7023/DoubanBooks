//
//  DataError.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import Foundation
enum DataError:Error {
    case readCollestionError(String)
    case readSingError(String)
    case entityExistsError(String)
    case deleteEntityError(String)
    case updateEntityError(String)
}
