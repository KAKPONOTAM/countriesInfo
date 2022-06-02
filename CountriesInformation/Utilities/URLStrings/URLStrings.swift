import Foundation

enum URLStrings {
    case firstPageURL
    case nextPageURL(nextPageURL: String)
    
    var stringURL: String {
        switch self {
        case .firstPageURL:
            return "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
        case .nextPageURL(let nextPageURL):
            return nextPageURL
        }
    }
}
