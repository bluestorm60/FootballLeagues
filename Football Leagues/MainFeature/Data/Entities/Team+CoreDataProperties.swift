//
//  Team+CoreDataProperties.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 16/09/2023.
//
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var shortName: String?
    @NSManaged public var crest: String?
    @NSManaged public var competition: Competition?

}

extension Team : Identifiable {

}
