import Foundation

/**
 `Keys` is a list of expected hidden key value pairs in `Keys.plist`, used for sensitive
 developer information like API keys and secrets.
 */
enum Keys: String {
    case apiURL = "api-url"
    case apiDevURL = "api-dev-url"
    case fabricAPIKey = "fabric-api-key"
    case googleClientID = "google-client-id"

    /**
     `value` is the string representation of the key. Implicitly unwrapped because
     the app should crash without Keys stored properly, while allowing you to check
     for nil with `value == nil`.
     */
    var value: String! {
        return Keys.keyDict[rawValue] as? String
    }

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
}
