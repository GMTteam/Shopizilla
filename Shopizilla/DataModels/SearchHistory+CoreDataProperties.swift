//
//  SearchHistory+CoreDataProperties.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 16/05/2022.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: String
    @NSManaged public var keyword: String

}

extension SearchHistory : Identifiable {

}
