import Foundation

enum URLStrings {
    case firstPageURL
    case secondPageURL(secondPageURL: String)
    
    var stringURL: String {
        switch self {
        case .firstPageURL:
            return "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
        case .secondPageURL:
            return "https://rawgit.com/NikitaAsabin/b37bf67c8668d54a517e02fdf0e0d435/raw/2021870812a13c6dbae1f8a0e9845661396c1e8d/page2.json"
        }
    }
}
