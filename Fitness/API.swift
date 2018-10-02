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

public final class AllGymsQuery: GraphQLQuery {
  public let operationDefinition =
    "query AllGyms {\n  gyms {\n    __typename\n    name\n    id\n    description\n    popular\n    times {\n      __typename\n      day\n      startTime\n      endTime\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("gyms", type: .list(.object(Gym.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(gyms: [Gym?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "gyms": gyms.flatMap { (value: [Gym?]) -> [ResultMap?] in value.map { (value: Gym?) -> ResultMap? in value.flatMap { (value: Gym) -> ResultMap in value.resultMap } } }])
    }

    public var gyms: [Gym?]? {
      get {
        return (resultMap["gyms"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Gym?] in value.map { (value: ResultMap?) -> Gym? in value.flatMap { (value: ResultMap) -> Gym in Gym(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Gym?]) -> [ResultMap?] in value.map { (value: Gym?) -> ResultMap? in value.flatMap { (value: Gym) -> ResultMap in value.resultMap } } }, forKey: "gyms")
      }
    }

    public struct Gym: GraphQLSelectionSet {
      public static let possibleTypes = ["GymType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("id", type: .scalar(GraphQLID.self)),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("popular", type: .list(.list(.scalar(Int.self)))),
        GraphQLField("times", type: .list(.object(Time.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String? = nil, id: GraphQLID? = nil, description: String? = nil, popular: [[Int?]?]? = nil, times: [Time?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "GymType", "name": name, "id": id, "description": description, "popular": popular, "times": times.flatMap { (value: [Time?]) -> [ResultMap?] in value.map { (value: Time?) -> ResultMap? in value.flatMap { (value: Time) -> ResultMap in value.resultMap } } }])
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

      public var description: String? {
        get {
          return resultMap["description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      public var popular: [[Int?]?]? {
        get {
          return resultMap["popular"] as? [[Int?]?]
        }
        set {
          resultMap.updateValue(newValue, forKey: "popular")
        }
      }

      public var times: [Time?]? {
        get {
          return (resultMap["times"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Time?] in value.map { (value: ResultMap?) -> Time? in value.flatMap { (value: ResultMap) -> Time in Time(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Time?]) -> [ResultMap?] in value.map { (value: Time?) -> ResultMap? in value.flatMap { (value: Time) -> ResultMap in value.resultMap } } }, forKey: "times")
        }
      }

      public struct Time: GraphQLSelectionSet {
        public static let possibleTypes = ["DayTimeRangeType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("day", type: .scalar(Int.self)),
          GraphQLField("startTime", type: .scalar(String.self)),
          GraphQLField("endTime", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(day: Int? = nil, startTime: String? = nil, endTime: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "DayTimeRangeType", "day": day, "startTime": startTime, "endTime": endTime])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var day: Int? {
          get {
            return resultMap["day"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "day")
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
      }
    }
  }
}

public final class AllGymNamesQuery: GraphQLQuery {
  public let operationDefinition =
    "query AllGymNames {\n  gyms {\n    __typename\n    name\n    id\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("gyms", type: .list(.object(Gym.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(gyms: [Gym?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "gyms": gyms.flatMap { (value: [Gym?]) -> [ResultMap?] in value.map { (value: Gym?) -> ResultMap? in value.flatMap { (value: Gym) -> ResultMap in value.resultMap } } }])
    }

    public var gyms: [Gym?]? {
      get {
        return (resultMap["gyms"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Gym?] in value.map { (value: ResultMap?) -> Gym? in value.flatMap { (value: ResultMap) -> Gym in Gym(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Gym?]) -> [ResultMap?] in value.map { (value: Gym?) -> ResultMap? in value.flatMap { (value: Gym) -> ResultMap in value.resultMap } } }, forKey: "gyms")
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
  }
}