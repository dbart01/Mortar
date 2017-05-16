# Mortar

[![Build Status](https://travis-ci.org/dbart01/Mortar.svg?branch=master)](https://travis-ci.org/dbart01/Mortar)
[![codecov](https://codecov.io/gh/dbart01/Mortar/branch/master/graph/badge.svg)](https://codecov.io/gh/dbart01/Mortar)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub release](https://img.shields.io/github/release/dbart01/mortar.svg)](https://github.com/dbart01/Mortar/releases/latest)
[![GitHub license](https://img.shields.io/badge/license-MIT-orange.svg)](https://github.com/dbart01/Mortar/blob/master/LICENSE)

A light-weight foundation for functional composition on iOS and MacOS.

The best way to describe this framework is using a metaphor. A single brick is often useless. Even a horde of bricks cannot build a robust structure on their own. A binding agent is necessary to hold the bricks in place, and that's `Mortar.framework`. Your application has all the building blocks but it needs glue to bind it all together to form robust processing pipelines for data flow. `Mortar` is a collection of operators that let you chain synchronous and asynchronous operations together.

## Case Study
Let's take a look at how `Mortar` helps simplify a complex flow in a network layer. In this example, we have two sources of data - `Cache` and `URLSession` - as well as a request builder that accepts a `Credentials` model.

```swift
struct Credentials {}

extension Session {
    func fetchUpdated(with request: URLRequest, completionHandler: @escaping (Result<(Data, URLResponse), NetworkError>) -> Void)
}

class Cache {
    func fetchCached(for request: URLRequest) -> Result<(Data, URLResponse), NetworkError>
}

class Request {
    func build(_ credentials: Credentials) -> URLRequest
}
```

### Building the pipeline

You may have noticed that `Session` is asynchronous and `Cache` returns it's results immedietly. In conventional implementation, one may be tempted to abstract cache access inside the network call and have `Session` manage that relationship. However, this is a bad idea and we want to maintain the single-responsibility principle. Instead, we can use functional composition:

```swift
let credentials = Credentials(...)
let pipeline    = client.buildRequest <<- cache.fetchCached <-> session.fetchUpdated

pipeline(credentials) { result in
    switch result {
    case .success(let response):
        print("Success: \(response)")
    case .failure(let error):
        print("Failure: \(error)")
    }
}
```

Let's decompose what's going on here. Essentially, we're combining three functions into a single function (pipeline) that takes `Credentials` and calls a `completionHandler` with either a cached result or a fresh response from the network. First, we'll need a request to send. We can build one using:

```swift
let pipeline = client.buildRequest
```

The type of `pipeline` is now `(Credentials) -> URLRequest`, same as the original function. Not very useful, yet. Next, we'll append a transformation using a compositional operator - `<<-`. The compositional operator takes two functions, `lhs` and `rhs`, and returns a new function that takes the input from `lhs` and returns the output from `rhs`. It's important to note, however, that `rhs` will be executed only if `lhs` returns `success`. If `lhs` fails, the pipeline will exit early. The `<<-` operator also has `AdditionPrecedence`. We'll see what that means later on. Let's go ahead and append the next transformation:

```swift
let pipeline = client.buildRequest <<- cache.fetchCached
```

The type of `pipelin` is now `(Credentials) -> Result<(Data, URLResponse), NetworkError>`. In this case, the compositon will always succeed since `buildRequest` doesn't return a `Result<Type, Error>`. If a function returns anything else, it is assumed to always succeed. So, the result of combining the input from `buildRequest` and the output from `fetchCached` is a function that takes `Credentials` and returns a `(Data, URLResponse)` tuple upon successful completion and a `NetworkError` on failure.

So now we have a pipeline that will return cached data for any request built with `Credentials` if it exists in cache, but we still need to hit the network if there's no cached response. This is where functional composition changes slightly. The pipeline needs another `fetchUpdated` step but we don't want to use the compositional operator here. Instead, what we want is the result from either `fetchCached` **or** `fetchUpdated`. We want mutual exclusivity. For this we can use the exclusive operator - `<->`. The exclusive operator takes two functions, `lhs` and `rhs`, and returns a result from either `lhs` if it succeeds **or** `rhs` if it succeeds **and** `lhs` fails. It's also important to note that `<->` operator has `MultiplicationPrecedence`, which means it's executed before any `<<-` operations. Let's update the pipeline to reflect this:

```swift
let pipeline = client.buildRequest <<- cache.fetchCached <-> session.fetchUpdated
```

The above can also be written as:

```swift
let fetchResponse = cache.fetchCached <-> session.fetchUpdated
let pipeline = client.buildRequest <<- fetchResponse
```
As you can see, exclusive operator is executed first to create a function that takes a `URLRequest` and executes a `completionHandler` with the response. Notice that the call to `fetchCached` is synchronous but the resulting function is async. This is because a sync function can be represented by an async equivalent but not vice versa. Both the composition operator and exclusive operator produce a function that a common denominator between `lhs` and `rhs`.

### Extending the pipeline

Using composition and exlusive operators we achieve a dcecoupling between various parts of our application. This is good because we can easily extend our processing pipeline in a predictable and testable manner. Give the pipeline from our previous case study:

```swift
let pipeline = client.buildRequest <<- cache.fetchCached <-> session.fetchUpdated
```
 
Let's recap. The pipeline above takes `Credentials` and produces `(Data, URLResponse)` tuple upon success. This is fine if we like working with raw `Data` but that's rarely every the case. Instead, what we want to get back is some nice domain specific models that are relevant to your application. We can easily achive this by adding another node to our processing pipeline. First, we'll need to define a function.

```swift
class Model {
    static func create(_ response: (Data, URLResponse)) -> Model
}
```
For simplicity, let's assume we only have one model in our application and it can be constructed from raw `Data` and a `URLResponse`. Next, we'll append that function to our pipeline using a compositional operator since we want the input to our `create` function to be the aggregate output of the pipeline.

```swift
let pipeline = client.buildRequest <<- cache.fetchCached <-> session.fetchUpdated <<- Model.create
```

And that's it! The type of `pipeline` is now `(Credentials) -> Result<Model, NetworkError>`. The best part is `Model.create` doesn't need to know or care if the response `Data` came from a local cache or over the network. It's all transparent. Using functional composition we eliminate complexity associated creating requests, conditionally handling cached and network responses and passing that data on to our parser to create models.
