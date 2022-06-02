import Foundation
import RealmSwift

@objcMembers
class CountriesRealmData: Object {
    dynamic var next: String = ""
    dynamic var key = "key"
    dynamic var countries: Results<CountryRealm>? {
        let realm = try? Realm()
        return realm?.objects(CountryRealm.self)
    }
    
    
    convenience init(next: String) {
        self.init()
        self.next = next
    }
    
    override class func primaryKey() -> String? {
        return #keyPath(key)
    }
}

@objcMembers
class CountryRealm: Object {
    dynamic var name: String = ""
    dynamic var continent: String = ""
    dynamic var capital: String = ""
    dynamic var population: Int = 0
    dynamic var smallDescription: String = ""
    dynamic var countryDescription: String = ""
    dynamic var image: String = ""
    dynamic var flag: String = ""
    dynamic var countryImageData: Data = Data()
    dynamic var images = List<String>()
    
    convenience init(name: String, continent: String, capital: String, population: Int, smallDescription: String, countryDescription: String, image: String, flag: String, countryImageData: Data, images: List<String>) {
        self.init()
        self.name = name
        self.continent = continent
        self.capital = capital
        self.population = population
        self.smallDescription = smallDescription
        self.countryDescription = countryDescription
        self.image = image
        self.flag = flag
        self.countryImageData = countryImageData
        self.images = images
    }
    
    override class func primaryKey() -> String? {
        return #keyPath(name)
    }
}
