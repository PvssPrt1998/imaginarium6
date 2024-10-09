
import Foundation
import CoreData


extension CategorySelected {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategorySelected> {
        return NSFetchRequest<CategorySelected>(entityName: "CategorySelected")
    }

    @NSManaged public var category: String

}

extension CategorySelected : Identifiable {

}
