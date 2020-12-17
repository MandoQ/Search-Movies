//
//  Favorites+CoreDataProperties.swift
//  Armando.Quintana-Lab4
//
//  Created by Mando Quintana on 11/9/20.
//  Copyright © 2020 Armando Quintana. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var image: Data?
    @NSManaged public var movieDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var score: String?
    @NSManaged public var date: String?

}
