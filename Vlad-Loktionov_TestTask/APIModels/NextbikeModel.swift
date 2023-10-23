import Foundation

struct NetworkResponse: Decodable {
    let network: Network
}

struct Network: Decodable {
    let stations: [Station]
}

struct Station: Decodable {
    let empty_slots: Int?
    let free_bikes: Int
    let latitude: Double
    let longitude: Double
    let name: String
}
