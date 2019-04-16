import Mortar

public func Log<T: Any>(object: T) {
    let description = String(describing: object)
    print("Object: \(description)")
}

public func Log<X, E: Error>(result: Result<X, E>) {
    switch result {
    case .success(let value):
        print("Result success: \(value)")
    case .failure(let error):
        print("Result error: \(error)")
    }
}
