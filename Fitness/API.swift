//  This file was automatically generated and should not be edited.

import Apollo

public final class ClassesAtGymQuery: GraphQLQuery {
  public let operationDefinition =
    "query ClassesAtGym {\n  classes(gymId: 0) {\n    __typename\n    gym {\n      __typename\n      name\n      id\n    }\n    details {\n      __typename\n      name\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("classes", arguments: ["gymId": 0], type: .list(.object(Class.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(classes: [Class?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "classes": classes.flatMap { (value: [Class?]) -> [ResultMap?] in value.map { (value: Class?) -> ResultMap? in value.flatMap { (value: Class) -> ResultMap in value.resultMap } } }])
    }

    public var classes: [Class?]? {
      get {
        return (resultMap["classes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Class?] in value.map { (value: ResultMap?) -> Class? in value.flatMap { (value: ResultMap) -> Class in Class(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Class?]) -> [ResultMap?] in value.map { (value: Class?) -> ResultMap? in value.flatMap { (value: Class) -> ResultMap in value.resultMap } } }, forKey: "classes")
      }
    }

    public struct Class: GraphQLSelectionSet {
      public static let possibleTypes = ["ClassType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("gym", type: .object(Gym.selections)),
        GraphQLField("details", type: .object(Detail.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(gym: Gym? = nil, details: Detail? = nil) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "gym": gym.flatMap { (value: Gym) -> ResultMap in value.resultMap }, "details": details.flatMap { (value: Detail) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var gym: Gym? {
        get {
          return (resultMap["gym"] as? ResultMap).flatMap { Gym(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "gym")
        }
      }

      public var details: Detail? {
        get {
          return (resultMap["details"] as? ResultMap).flatMap { Detail(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "details")
        }
      }

      public struct Gym: GraphQLSelectionSet {
        public static let possibleTypes = ["GymType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String? = nil, id: GraphQLID? = nil) {
          self.init(unsafeResultMap: ["__typename": "GymType", "name": name, "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }

      public struct Detail: GraphQLSelectionSet {
        public static let possibleTypes = ["ClassDetailType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "ClassDetailType", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}