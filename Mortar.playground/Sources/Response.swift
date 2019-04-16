import Foundation

public class Response<T: ModelType>: ModelType {

    public let count:    Int
    public let next:     String?
    public let previous: String?
    public let results:  [T]
    
    public required init(json: JSON) {
        self.count    = json["count"]    as! Int
        self.next     = json["next"]     as? String
        self.previous = json["previous"] as? String
        let results   = json["results"]  as! [JSON]
        self.results  = [T].from(results)
    }
    
    public static func generate(json: JSON) -> Response<T> {
        return Response<T>(json: json)
    }
}
