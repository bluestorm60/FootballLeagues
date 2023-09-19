//
//  Competition+CoreDataProperties.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 16/09/2023.
//
//

import Foundation
import CoreData


extension Competition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Competition> {
        return NSFetchRequest<Competition>(entityName: "Competition")
    }

    @NSManaged public var areaName: String?
    @NSManaged public var code: String?
    @NSManaged public var emblem: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var numberOfmatches: String?
    @NSManaged public var numberOfSeasons: String?
    @NSManaged public var numberOfTeams: String?
    @NSManaged public var type: String?
    @NSManaged public var teams: Set<Team>?
    
    public var team: [Team]{
        let setOfTeam = teams
        return setOfTeam!.sorted{
            $0.id > $1.id
        }
        
    }

}

// MARK: Generated accessors for teams
extension Competition {

    @objc(addTeamsObject:)
    @NSManaged public func addToTeams(_ value: Team)

    @objc(removeTeamsObject:)
    @NSManaged public func removeFromTeams(_ value: Team)

    @objc(addTeams:)
    @NSManaged public func addToTeams(_ values: NSSet)

    @objc(removeTeams:)
    @NSManaged public func removeFromTeams(_ values: NSSet)

}

extension Competition : Identifiable {

}

extension Competition {
    func configure(with source: LeaguesUIModel.CompetitionUIModel) {
        id = Int64(source.id)
        name = source.name
        areaName = source.areaName
        code = source.code
        type = source.type
        emblem = source.emblem
        numberOfmatches = source.numberOfmatches
        numberOfTeams = source.numberOfTeams
        numberOfSeasons = source.numberOfSeasons
    }
}
