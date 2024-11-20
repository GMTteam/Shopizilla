//
//  RecentlyViewed+CoreDataProperties.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 16/05/2022.
//
//

import Foundation
import CoreData


extension RecentlyViewed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentlyViewed> {
        return NSFetchRequest<RecentlyViewed>(entityName: "RecentlyViewed")
    }

    @NSManaged public var id: String
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var productID: String
    @NSManaged public var subcategory: String
}

extension RecentlyViewed : Identifiable {

}
