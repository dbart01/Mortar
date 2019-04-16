import Foundation

public class Person: ModelType, CustomStringConvertible {
    
    public let name:   String
    public let height: String
    public let mass:   String
    public let gender: String
    
    public required init(json: JSON) {
        self.name   = json["name"]   as! String
        self.height = json["height"] as! String
        self.mass   = json["mass"]   as! String
        self.gender = json["gender"] as! String
    }
    
    public var description: String {
        return "<\(self.name), height: \(self.height), mass: \(self.mass), gender: \(self.gender)>"
    }
}
