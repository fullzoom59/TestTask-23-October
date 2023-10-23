import CoreLocation

protocol LocationPermissionProtocol {
    func requestLocationPermission(completion: @escaping (CLAuthorizationStatus) -> Void)
    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void)
}
