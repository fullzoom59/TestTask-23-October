import CoreLocation
import Foundation

class CyclingStationViewModel: CyclingStationModelProtocol {
    public var networkService = NetworkService()
    private let locationPermission: LocationPermission
    var cyclingStation: [Station] = []
    var currentLocation: CLLocation?
    
    private var isFirstLaunch: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isFirstLaunch")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFirstLaunch")
        }
    }
    
    init() {
        self.locationPermission = LocationPermission()
    }
    
    
    func fetchCyclingStation(completion: @escaping () -> Void) {
        networkService.fetchCyclingStation { [weak self] (result: Result<NetworkResponse, NetworkError>) in
            switch result {
            case .success(let success):
                var stations = success.network.stations
                if let currentLocation = self?.currentLocation {
                    stations.sort { station1, station2 in
                        let loc1 = CLLocation(latitude: station1.latitude, longitude: station1.longitude)
                        let loc2 = CLLocation(latitude: station2.latitude, longitude: station2.longitude)
                        return loc1.distance(from: currentLocation) < loc2.distance(from: currentLocation)
                    }
                } else {
                    stations.sort { $0.name.lowercased() < $1.name.lowercased() }
                }
                self?.cyclingStation = stations
                completion()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func requestPermissionAndFetchLocation() {
        if !isFirstLaunch {
            isFirstLaunch = true
            requestPermission { [weak self] status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorizedWhenInUse, .authorizedAlways:
                        self?.fetchCurrentLocation { result in
                            switch result {
                            case .success(let location):
                                print("The exact location of the user: \(location)")
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    default:
                        print("Location permission not granted.")
                    }
                }
            }
        }
    }
    
    public func requestPermission(completion: @escaping (CLAuthorizationStatus) -> Void) {
        locationPermission.requestLocationPermission { status in
            completion(status)
        }
    }
    
    public func fetchCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationPermission.getCurrentLocation { result in
            completion(result)
        }
    }
    
    
}
