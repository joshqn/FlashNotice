//
//  Notice+CoreDataProperties.swift
//  FlashNotice
//
//  Created by JoshuaKuehn on 9/25/17.
//  Copyright © 2017 JoshuaKuehn. All rights reserved.
//
//

import Foundation
import CoreData


extension Notice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notice> {
        return NSFetchRequest<Notice>(entityName: "Notice")
    }

    @NSManaged public var title: String?

}
