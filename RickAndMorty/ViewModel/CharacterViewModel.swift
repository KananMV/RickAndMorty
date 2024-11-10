import Foundation
import Alamofire
import Combine

class CharacterViewModel {
    var characters: [Character] = []
    var allCharacters: [Character] = []
    var currentPage = 1
    var baseUrl = "https://rickandmortyapi.com/api/character/"
    lazy var apiUrl = "https://rickandmortyapi.com/api/character/?page=\(currentPage)"
    let genderOptions = ["None", "Male", "Female", "genderless", "unknown"]
    let speciesOptions = ["None", "Human", "Alien", "Humanoid", "Poopybutthole", "Unknown"]
    var selectedGender: String?
    var selectedSpecies: String?
    var searchedTitle: String?
    
    @Published var success: SuccessEnum? = nil
    
    func fetchCharacters(completion: @escaping () -> Void) {
        AF.request(apiUrl)
            .validate()
            .responseDecodable(of: CharacterResponse.self) { response in
                switch response.result {
                case .success(let characterResponse):
                    self.allCharacters = characterResponse.results
                    self.characters = self.allCharacters
                    completion()
                case .failure(let error):
                    print("Error fetching characters: \(error)")
                }
            }
    }
    func fetchCharactersByTitle(completion: @escaping ([Character]) -> Void) {
        var url = baseUrl + "?page=\(currentPage)"
        if let searchedTitle {
            url += "&name=\(searchedTitle)"
        }
        if let selectedGender {
            url += "&gender=\(selectedGender)"
        }
        if let selectedSpecies {
            url += "&species=\(selectedSpecies)"
        }
        AF.request(url)
            .validate()
            .responseDecodable(of: CharacterResponse.self) { response in
                switch response.result {
                case .success(let characterResponse):
                    completion(characterResponse.results)
                case .failure(let error):
                    print("Error fetching characters: \(error)")
                    completion([])
                }
            }
    }
    func fetchMoreCharacters(completion: @escaping () -> Void) {
        currentPage += 1
        fetchCharactersByTitle { newCharacters in
            self.characters.append(contentsOf: newCharacters)  
            completion()
        }
    }
    func filterCharactersByGender(gender: String?, completion: @escaping () -> Void) {
        selectedGender = gender
        fetchCharactersByTitle { filteredCharacters in
            self.characters = filteredCharacters
            completion()
        }
    }

    func filterCharactersBySpecies(species: String?, completion: @escaping () -> Void) {
        selectedSpecies = species
        fetchCharactersByTitle { filteredCharacters in
            self.characters = filteredCharacters
            completion()
        }
    }
}
extension CharacterViewModel {
    enum SuccessEnum {
        case fetchChar
        case fetchCharByTitle
    }
}
