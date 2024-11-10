import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let gender: String
    let species: String
    let location: Location
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case gender
        case species
        case location
        case image
    }
}

struct Location: Decodable {
    let name: String
}
 
struct CharacterResponse: Decodable {
    let results: [Character]
}
