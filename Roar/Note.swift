//
//  Note.swift
//  
//
//  Created by Denzel Carter on 6/25/15.
//
//

import Foundation
import CoreData

class Note: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var url: String

}
