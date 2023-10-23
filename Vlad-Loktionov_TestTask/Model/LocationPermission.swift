import CoreLocation

class LocationPermission: NSObject, CLLocationManagerDelegate, LocationPermissionProtocol {

    private var locationManager: CLLocationManager?
    private var permissionCompletion: ((CLAuthorizationStatus) -> Void)?
    private var locationCompletion: ((Result<CLLocation, Error>) -> Void)?

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
    }

    func requestLocationPermission(completion: @escaping (CLAuthorizationStatus) -> Void) {
        self.permissionCompletion = completion
        locationManager?.requestWhenInUseAuthorization()
    }

    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        self.locationCompletion = completion
        locationManager?.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        permissionCompletion?(status)
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationCompletion?(.success(location))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(.failure(error))
    }
}
