//  This file was automatically generated and should not be edited.

import Apollo

public final class AllClassesInstancesQuery: GraphQLQuery {
  public let operationDefinition =
    "query AllClassesInstances {\n  classes {\n    __typename\n    id\n    gymId\n    gym {\n      __typename\n      name\n    }\n    details {\n      __typename\n      id\n      name\n      description\n      tags {\n        __typename\n        label\n      }\n    }\n    imageUrl\n    startTime\n    endTime\n    instructor\n    isCancelled\n  }\n}"

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
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("gymId", type: .scalar(String.self)),
        GraphQLField("gym", type: .object(Gym.selections)),
        GraphQLField("details", type: .nonNull(.object(Detail.selections))),
        GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("startTime", type: .scalar(String.self)),
        GraphQLField("endTime", type: .scalar(String.self)),
        GraphQLField("instructor", type: .nonNull(.scalar(String.self))),
        GraphQLField("isCancelled", type: .nonNull(.scalar(Bool.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, gymId: String? = nil, gym: Gym? = nil, details: Detail, imageUrl: String, startTime: String? = nil, endTime: String? = nil, instructor: String, isCancelled: Bool) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "id": id, "gymId": gymId, "gym": gym.flatMap { (value: Gym) -> ResultMap in value.resultMap }, "details": details.resultMap, "imageUrl": imageUrl, "startTime": startTime, "endTime": endTime, "instructor": instructor, "isCancelled": isCancelled])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var gymId: String? {
        get {
          return resultMap["gymId"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "gymId")
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

      public var details: Detail {
        get {
          return Detail(unsafeResultMap: resultMap["details"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "details")
        }
      }

      public var imageUrl: String {
        get {
          return resultMap["imageUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageUrl")
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

      public var instructor: String {
        get {
          return resultMap["instructor"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "instructor")
        }
      }

      public var isCancelled: Bool {
        get {
          return resultMap["isCancelled"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isCancelled")
        }
      }

      public struct Gym: GraphQLSelectionSet {
        public static let possibleTypes = ["GymType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
          self.init(unsafeResultMap: ["__typename": "GymType", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Detail: GraphQLSelectionSet {
        public static let possibleTypes = ["ClassDetailType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("tags", type: .nonNull(.list(.object(Tag.selections)))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: String, name: String, description: String, tags: [Tag?]) {
          self.init(unsafeResultMap: ["__typename": "ClassDetailType", "id": id, "name": name, "description": description, "tags": tags.map { (value: Tag?) -> ResultMap? in value.flatMap { (value: Tag) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: String {
          get {
            return resultMap["id"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var description: String {
          get {
            return resultMap["description"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }

        public var tags: [Tag?] {
          get {
            return (resultMap["tags"] as! [ResultMap?]).map { (value: ResultMap?) -> Tag? in value.flatMap { (value: ResultMap) -> Tag in Tag(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Tag?) -> ResultMap? in value.flatMap { (value: Tag) -> ResultMap in value.resultMap } }, forKey: "tags")
          }
        }

        public struct Tag: GraphQLSelectionSet {
          public static let possibleTypes = ["TagType"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("label", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(label: String) {
            self.init(unsafeResultMap: ["__typename": "TagType", "label": label])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var label: String {
            get {
              return resultMap["label"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "label")
            }
          }
        }
      }
    }
  }
}

public final class TodaysClassesQuery: GraphQLQuery {
  public let operationDefinition =
    "query TodaysClasses($date: Date) {\n  classes(day: $date) {\n    __typename\n    id\n    gymId\n    gym {\n      __typename\n      name\n    }\n    details {\n      __typename\n      id\n      name\n      description\n      tags {\n        __typename\n        label\n      }\n    }\n    imageUrl\n    startTime\n    endTime\n    date\n    instructor\n    isCancelled\n    location\n  }\n}"

  public var date: String?

  public init(date: String? = nil) {
    self.date = date
  }

  public var variables: GraphQLMap? {
    return ["date": date]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("classes", arguments: ["day": GraphQLVariable("date")], type: .list(.object(Class.selections))),
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
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("gymId", type: .scalar(String.self)),
        GraphQLField("gym", type: .object(Gym.selections)),
        GraphQLField("details", type: .nonNull(.object(Detail.selections))),
        GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("startTime", type: .scalar(String.self)),
        GraphQLField("endTime", type: .scalar(String.self)),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("instructor", type: .nonNull(.scalar(String.self))),
        GraphQLField("isCancelled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("location", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, gymId: String? = nil, gym: Gym? = nil, details: Detail, imageUrl: String, startTime: String? = nil, endTime: String? = nil, date: String, instructor: String, isCancelled: Bool, location: String) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "id": id, "gymId": gymId, "gym": gym.flatMap { (value: Gym) -> ResultMap in value.resultMap }, "details": details.resultMap, "imageUrl": imageUrl, "startTime": startTime, "endTime": endTime, "date": date, "instructor": instructor, "isCancelled": isCancelled, "location": location])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var gymId: String? {
        get {
          return resultMap["gymId"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "gymId")
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

      public var details: Detail {
        get {
          return Detail(unsafeResultMap: resultMap["details"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "details")
        }
      }

      public var imageUrl: String {
        get {
          return resultMap["imageUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageUrl")
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

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      public var instructor: String {
        get {
          return resultMap["instructor"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "instructor")
        }
      }

      public var isCancelled: Bool {
        get {
          return resultMap["isCancelled"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isCancelled")
        }
      }

      public var location: String {
        get {
          return resultMap["location"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "location")
        }
      }

      public struct Gym: GraphQLSelectionSet {
        public static let possibleTypes = ["GymType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
          self.init(unsafeResultMap: ["__typename": "GymType", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Detail: GraphQLSelectionSet {
        public static let possibleTypes = ["ClassDetailType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("tags", type: .nonNull(.list(.object(Tag.selections)))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: String, name: String, description: String, tags: [Tag?]) {
          self.init(unsafeResultMap: ["__typename": "ClassDetailType", "id": id, "name": name, "description": description, "tags": tags.map { (value: Tag?) -> ResultMap? in value.flatMap { (value: Tag) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: String {
          get {
            return resultMap["id"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var description: String {
          get {
            return resultMap["description"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }

        public var tags: [Tag?] {
          get {
            return (resultMap["tags"] as! [ResultMap?]).map { (value: ResultMap?) -> Tag? in value.flatMap { (value: ResultMap) -> Tag in Tag(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Tag?) -> ResultMap? in value.flatMap { (value: Tag) -> ResultMap in value.resultMap } }, forKey: "tags")
          }
        }

        public struct Tag: GraphQLSelectionSet {
          public static let possibleTypes = ["TagType"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("label", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(label: String) {
            self.init(unsafeResultMap: ["__typename": "TagType", "label": label])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var label: String {
            get {
              return resultMap["label"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "label")
            }
          }
        }
      }
    }
  }
}

public final class ClassesAtGymQuery: GraphQLQuery {
  public let operationDefinition =
    "query ClassesAtGym {\n  classes(gymId: \"\") {\n    __typename\n    gym {\n      __typename\n      name\n      id\n    }\n    details {\n      __typename\n      name\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("classes", arguments: ["gymId": ""], type: .list(.object(Class.selections))),
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
        GraphQLField("details", type: .nonNull(.object(Detail.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(gym: Gym? = nil, details: Detail) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "gym": gym.flatMap { (value: Gym) -> ResultMap in value.resultMap }, "details": details.resultMap])
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

      public var details: Detail {
        get {
          return Detail(unsafeResultMap: resultMap["details"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "details")
        }
      }

      public struct Gym: GraphQLSelectionSet {
        public static let possibleTypes = ["GymType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String, id: String) {
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

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var id: String {
          get {
            return resultMap["id"]! as! String
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
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
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

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}

public final class AllIntructorsQuery: GraphQLQuery {
  public let operationDefinition =
    "query AllIntructors {\n  classes {\n    __typename\n    instructor\n  }\n}"

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
        GraphQLField("instructor", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(instructor: String) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "instructor": instructor])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var instructor: String {
        get {
          return resultMap["instructor"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "instructor")
        }
      }
    }
  }
}

public final class AllClassNamesQuery: GraphQLQuery {
  public let operationDefinition =
    "query AllClassNames {\n  classes {\n    __typename\n    details {\n      __typename\n      name\n    }\n  }\n}"

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
        GraphQLField("details", type: .nonNull(.object(Detail.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(details: Detail) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "details": details.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var details: Detail {
        get {
          return Detail(unsafeResultMap: resultMap["details"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "details")
        }
      }

      public struct Detail: GraphQLSelectionSet {
        public static let possibleTypes = ["ClassDetailType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
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

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}

public final class ClassesByTypeQuery: GraphQLQuery {
  public let operationDefinition =
    "query ClassesByType($classNames: [String]) {\n  classes(detailIds: $classNames) {\n    __typename\n    id\n    gymId\n    details {\n      __typename\n      id\n      name\n      description\n    }\n    imageUrl\n    startTime\n    endTime\n    date\n    instructor\n    isCancelled\n    location\n  }\n}"

  public var classNames: [String?]?

  public init(classNames: [String?]? = nil) {
    self.classNames = classNames
  }

  public var variables: GraphQLMap? {
    return ["classNames": classNames]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("classes", arguments: ["detailIds": GraphQLVariable("classNames")], type: .list(.object(Class.selections))),
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
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("gymId", type: .scalar(String.self)),
        GraphQLField("details", type: .nonNull(.object(Detail.selections))),
        GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("startTime", type: .scalar(String.self)),
        GraphQLField("endTime", type: .scalar(String.self)),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("instructor", type: .nonNull(.scalar(String.self))),
        GraphQLField("isCancelled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("location", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, gymId: String? = nil, details: Detail, imageUrl: String, startTime: String? = nil, endTime: String? = nil, date: String, instructor: String, isCancelled: Bool, location: String) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "id": id, "gymId": gymId, "details": details.resultMap, "imageUrl": imageUrl, "startTime": startTime, "endTime": endTime, "date": date, "instructor": instructor, "isCancelled": isCancelled, "location": location])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var gymId: String? {
        get {
          return resultMap["gymId"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "gymId")
        }
      }

      public var details: Detail {
        get {
          return Detail(unsafeResultMap: resultMap["details"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "details")
        }
      }

      public var imageUrl: String {
        get {
          return resultMap["imageUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageUrl")
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

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      public var instructor: String {
        get {
          return resultMap["instructor"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "instructor")
        }
      }

      public var isCancelled: Bool {
        get {
          return resultMap["isCancelled"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isCancelled")
        }
      }

      public var location: String {
        get {
          return resultMap["location"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "location")
        }
      }

      public struct Detail: GraphQLSelectionSet {
        public static let possibleTypes = ["ClassDetailType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: String, name: String, description: String) {
          self.init(unsafeResultMap: ["__typename": "ClassDetailType", "id": id, "name": name, "description": description])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: String {
          get {
            return resultMap["id"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var description: String {
          get {
            return resultMap["description"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }
      }
    }
  }
}

public final class ClassesAtGymByDayQuery: GraphQLQuery {
  public let operationDefinition =
    "query ClassesAtGymByDay($day: Date, $gym: String) {\n  classes(day: $day, gymId: $gym) {\n    __typename\n    id\n    gymId\n    gym {\n      __typename\n      name\n    }\n    details {\n      __typename\n      id\n      name\n      description\n      tags {\n        __typename\n        label\n      }\n    }\n    imageUrl\n    startTime\n    endTime\n    instructor\n    isCancelled\n    location\n  }\n}"

  public var day: String?
  public var gym: String?

  public init(day: String? = nil, gym: String? = nil) {
    self.day = day
    self.gym = gym
  }

  public var variables: GraphQLMap? {
    return ["day": day, "gym": gym]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("classes", arguments: ["day": GraphQLVariable("day"), "gymId": GraphQLVariable("gym")], type: .list(.object(Class.selections))),
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
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("gymId", type: .scalar(String.self)),
        GraphQLField("gym", type: .object(Gym.selections)),
        GraphQLField("details", type: .nonNull(.object(Detail.selections))),
        GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
        GraphQLField("startTime", type: .scalar(String.self)),
        GraphQLField("endTime", type: .scalar(String.self)),
        GraphQLField("instructor", type: .nonNull(.scalar(String.self))),
        GraphQLField("isCancelled", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("location", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, gymId: String? = nil, gym: Gym? = nil, details: Detail, imageUrl: String, startTime: String? = nil, endTime: String? = nil, instructor: String, isCancelled: Bool, location: String) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "id": id, "gymId": gymId, "gym": gym.flatMap { (value: Gym) -> ResultMap in value.resultMap }, "details": details.resultMap, "imageUrl": imageUrl, "startTime": startTime, "endTime": endTime, "instructor": instructor, "isCancelled": isCancelled, "location": location])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var gymId: String? {
        get {
          return resultMap["gymId"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "gymId")
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

      public var details: Detail {
        get {
          return Detail(unsafeResultMap: resultMap["details"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "details")
        }
      }

      public var imageUrl: String {
        get {
          return resultMap["imageUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageUrl")
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

      public var instructor: String {
        get {
          return resultMap["instructor"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "instructor")
        }
      }

      public var isCancelled: Bool {
        get {
          return resultMap["isCancelled"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isCancelled")
        }
      }

      public var location: String {
        get {
          return resultMap["location"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "location")
        }
      }

      public struct Gym: GraphQLSelectionSet {
        public static let possibleTypes = ["GymType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
          self.init(unsafeResultMap: ["__typename": "GymType", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Detail: GraphQLSelectionSet {
        public static let possibleTypes = ["ClassDetailType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("tags", type: .nonNull(.list(.object(Tag.selections)))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: String, name: String, description: String, tags: [Tag?]) {
          self.init(unsafeResultMap: ["__typename": "ClassDetailType", "id": id, "name": name, "description": description, "tags": tags.map { (value: Tag?) -> ResultMap? in value.flatMap { (value: Tag) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: String {
          get {
            return resultMap["id"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var description: String {
          get {
            return resultMap["description"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }

        public var tags: [Tag?] {
          get {
            return (resultMap["tags"] as! [ResultMap?]).map { (value: ResultMap?) -> Tag? in value.flatMap { (value: ResultMap) -> Tag in Tag(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Tag?) -> ResultMap? in value.flatMap { (value: Tag) -> ResultMap in value.resultMap } }, forKey: "tags")
          }
        }

        public struct Tag: GraphQLSelectionSet {
          public static let possibleTypes = ["TagType"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("label", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(label: String) {
            self.init(unsafeResultMap: ["__typename": "TagType", "label": label])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var label: String {
            get {
              return resultMap["label"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "label")
            }
          }
        }
      }
    }
  }
}

public final class GetTagsQuery: GraphQLQuery {
  public let operationDefinition =
    "query GetTags {\n  classes {\n    __typename\n    details {\n      __typename\n      tags {\n        __typename\n        label\n        imageUrl\n      }\n    }\n  }\n}"

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
        GraphQLField("details", type: .nonNull(.object(Detail.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(details: Detail) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "details": details.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var details: Detail {
        get {
          return Detail(unsafeResultMap: resultMap["details"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "details")
        }
      }

      public struct Detail: GraphQLSelectionSet {
        public static let possibleTypes = ["ClassDetailType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tags", type: .nonNull(.list(.object(Tag.selections)))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(tags: [Tag?]) {
          self.init(unsafeResultMap: ["__typename": "ClassDetailType", "tags": tags.map { (value: Tag?) -> ResultMap? in value.flatMap { (value: Tag) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tags: [Tag?] {
          get {
            return (resultMap["tags"] as! [ResultMap?]).map { (value: ResultMap?) -> Tag? in value.flatMap { (value: ResultMap) -> Tag in Tag(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Tag?) -> ResultMap? in value.flatMap { (value: Tag) -> ResultMap in value.resultMap } }, forKey: "tags")
          }
        }

        public struct Tag: GraphQLSelectionSet {
          public static let possibleTypes = ["TagType"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("label", type: .nonNull(.scalar(String.self))),
            GraphQLField("imageUrl", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(label: String, imageUrl: String) {
            self.init(unsafeResultMap: ["__typename": "TagType", "label": label, "imageUrl": imageUrl])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var label: String {
            get {
              return resultMap["label"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "label")
            }
          }

          public var imageUrl: String {
            get {
              return resultMap["imageUrl"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "imageUrl")
            }
          }
        }
      }
    }
  }
}

public final class AllGymsQuery: GraphQLQuery {
  public let operationDefinition =
    "query AllGyms {\n  gyms {\n    __typename\n    name\n    id\n    imageUrl\n    description\n    popular\n    times {\n      __typename\n      day\n      startTime\n      endTime\n    }\n  }\n}"

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
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("imageUrl", type: .scalar(String.self)),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("popular", type: .list(.list(.scalar(Int.self)))),
        GraphQLField("times", type: .nonNull(.list(.object(Time.selections)))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String, id: String, imageUrl: String? = nil, description: String, popular: [[Int?]?]? = nil, times: [Time?]) {
        self.init(unsafeResultMap: ["__typename": "GymType", "name": name, "id": id, "imageUrl": imageUrl, "description": description, "popular": popular, "times": times.map { (value: Time?) -> ResultMap? in value.flatMap { (value: Time) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var imageUrl: String? {
        get {
          return resultMap["imageUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageUrl")
        }
      }

      public var description: String {
        get {
          return resultMap["description"]! as! String
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

      public var times: [Time?] {
        get {
          return (resultMap["times"] as! [ResultMap?]).map { (value: ResultMap?) -> Time? in value.flatMap { (value: ResultMap) -> Time in Time(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Time?) -> ResultMap? in value.flatMap { (value: Time) -> ResultMap in value.resultMap } }, forKey: "times")
        }
      }

      public struct Time: GraphQLSelectionSet {
        public static let possibleTypes = ["DayTimeRangeType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("day", type: .nonNull(.scalar(Int.self))),
          GraphQLField("startTime", type: .nonNull(.scalar(String.self))),
          GraphQLField("endTime", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(day: Int, startTime: String, endTime: String) {
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

        public var day: Int {
          get {
            return resultMap["day"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "day")
          }
        }

        public var startTime: String {
          get {
            return resultMap["startTime"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "startTime")
          }
        }

        public var endTime: String {
          get {
            return resultMap["endTime"]! as! String
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
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String, id: String) {
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

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class GetInstructorsQuery: GraphQLQuery {
  public let operationDefinition =
    "query getInstructors {\n  classes {\n    __typename\n    instructor\n  }\n}"

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
        GraphQLField("instructor", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(instructor: String) {
        self.init(unsafeResultMap: ["__typename": "ClassType", "instructor": instructor])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var instructor: String {
        get {
          return resultMap["instructor"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "instructor")
        }
      }
    }
  }
}