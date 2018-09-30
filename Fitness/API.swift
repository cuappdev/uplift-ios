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

public final class AllClassesInstancesQuery: GraphQLQuery {
  public let operationDefinition =
    "query AllClassesInstances {\n  classes {\n    __typename\n    id\n    gymId\n    details {\n      __typename\n      id\n      name\n      description\n      tags\n    }\n    startTime\n    endTime\n    instructor\n    isCancelled\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("classes", type: .list(.object(Class.selections))),
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
        GraphQLField("id", type: .scalar(GraphQLID.self)),
        GraphQLField("gymId", type: .scalar(GraphQLID.self)),
        GraphQLField("details", type: .object(Detail.selections)),
        GraphQLField("startTime", type: .scalar(String.self)),
        GraphQLField("endTime", type: .scalar(String.self)),
        GraphQLField("instructor", type: .scalar(String.self)),
        GraphQLField("isCancelled", type: .scalar(Bool.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, gymId: GraphQLID? = nil, details: Detail? = nil, startTime: String? = nil, endTime: String? = nil, instructor: String? = nil, isCancelled: Bool? = nil) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "id": id, "gymId": gymId, "details": details.flatMap { (value: Detail) -> ResultMap in value.resultMap }, "startTime": startTime, "endTime": endTime, "instructor": instructor, "isCancelled": isCancelled])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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

      public var gymId: GraphQLID? {
        get {
          return resultMap["gymId"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "gymId")
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

      public var startTime: String? {
        get {
          return resultMap["startTime"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "startTime")
        }
      }

      public var endTime: String? {
        get {
          return resultMap["endTime"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "endTime")
        }
      }

      public var instructor: String? {
        get {
          return resultMap["instructor"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "instructor")
        }
      }

      public var isCancelled: Bool? {
        get {
          return resultMap["isCancelled"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isCancelled")
        }
      }

      public struct Detail: GraphQLSelectionSet {
        public static let possibleTypes = ["ClassDetailType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("tags", type: .list(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, name: String? = nil, description: String? = nil, tags: [String?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "ClassDetailType", "id": id, "name": name, "description": description, "tags": tags])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
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

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var description: String? {
          get {
            return resultMap["description"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }

        public var tags: [String?]? {
          get {
            return resultMap["tags"] as? [String?]
          }
          set {
            resultMap.updateValue(newValue, forKey: "tags")
          }
        }
      }
    }
  }
}