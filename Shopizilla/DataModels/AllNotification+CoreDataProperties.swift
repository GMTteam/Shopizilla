//
//  AllNotification+CoreDataProperties.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 16/05/2022.
//
//

import Foundation
import CoreData


extension AllNotification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllNotification> {
        return NSFetchRequest<AllNotification>(entityName: "AllNotification")
    }

    @NSManaged public var id: String
    @NSManaged public var isOn: Bool

}

extension AllNotification : Identifiable {

}
