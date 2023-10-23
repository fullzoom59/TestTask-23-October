import CoreLocation

protocol CyclingStationModelProtocol {
    var cyclingStation: [Station] { get }
    var currentLocation: CLLocation? { get }
    
    func fetchCyclingStation(completion: @escaping () -> Void)
    func requestPermissionAndFetchLocation()
}
