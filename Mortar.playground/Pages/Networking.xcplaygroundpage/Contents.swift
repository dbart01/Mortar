//: [Previous](@previous)

import PlaygroundSupport
import Mortar

PlaygroundPage.current.needsIndefiniteExecution = true

let pipeline = Swapi.people <<- Request.to -< Log <<- Session.fetch <<- Parser.parse -< Log <<- Response<Person>.generate

pipeline() { result in
    switch result {
    case .success(let response):
        print(response.results[3])
    case .failure(let error):
        print("Error: \(error)")
    }
}

//: [Next](@next)
