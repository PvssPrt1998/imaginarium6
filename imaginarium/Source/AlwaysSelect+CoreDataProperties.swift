import Foundation
import CoreData


extension AlwaysSelect {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlwaysSelect> {
        return NSFetchRequest<AlwaysSelect>(entityName: "AlwaysSelect")
    }

    @NSManaged public var select: Bool

}

extension AlwaysSelect : Identifiable {

}
