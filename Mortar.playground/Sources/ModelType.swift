import Foundation

public protocol ModelType {
    init(json: JSON)
}

extension Array where Element: ModelType {
    
    public static func from(_ json: [JSON]) -> [Element] {
        return json.map {
            Element(json: $0)
        }
    }
}
