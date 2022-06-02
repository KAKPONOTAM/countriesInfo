import Foundation
import RealmSwift

@objcMembers
class CountryRealm: Object {
    dynamic var name: String
    dynamic var continent: String
    dynamic var capital: String
    dynamic var population: Int
    dynamic var smallDescription: String
    dynamic var countryDescription: String
    dynamic var image: String
    
    init(name: String, continent: String, capital: String, population: Int, smallDescription: String, countryDescription: String, image: String) {
        self.name = name
        self.continent = continent
        self.capital = capital
        self.population = population
        self.smallDescription = smallDescription
        self.countryDescription = countryDescription
        self.image = image
    }
    
    override class func primaryKey() -> String? {
        return #keyPath(name)
    }
}
