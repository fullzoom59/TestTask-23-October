import UIKit

class CyclingStationViewController: UIViewController {
    private var weatherViewModel: CyclingStationViewModel?
    
    private lazy var cyclingStationTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CyclingStationTableViewCell.self, forCellReuseIdentifier: CyclingStationTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        fetchCyclingStation()
        setupUI()
    }

    init(viewModel: CyclingStationViewModel) {
        self.weatherViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Cycling Station"
        view.addSubview(cyclingStationTableView)
        NSLayoutConstraint.activate([
            cyclingStationTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cyclingStationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cyclingStationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cyclingStationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func requestLocation() {
        let didCompleteFirstLaunch = UserDefaults.standard.bool(forKey: "didCompleteFirstLaunch")
        if !didCompleteFirstLaunch {
            weatherViewModel?.requestPermission { [weak self] status in
                switch status {
                case .notDetermined:
                    self?.locationRequestAlert()
                case .denied, .restricted:
                    self?.locationRequestAlert()
                case .authorizedWhenInUse, .authorizedAlways:
                    self?.fetchCurrentLocation()
                }
            }
        } else {
            fetchCurrentLocation()
        }
    }

    private func fetchCurrentLocation() {
        weatherViewModel?.fetchCurrentLocation { [weak self] result in
            switch result {
            case .success(let location):
                self?.weatherViewModel?.currentLocation = location
                self?.fetchCyclingStation()
                UserDefaults.standard.set(true, forKey: "didCompleteFirstLaunch")
            case .failure(let failure):
                print("Error: \(failure.localizedDescription)")
                self?.fetchCyclingStation()
            }
        }
    }
    
    private func locationRequestAlert() {
        let alert = UIAlertController(title: "Attention", message: "We will sort places by name as you have not provided access to geolocation", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func fetchCyclingStation() {
        weatherViewModel?.fetchCyclingStation {
            DispatchQueue.main.async { [weak self] in
                self?.cyclingStationTableView.reloadData()
            }
        }
    }
}

extension CyclingStationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cyclingStationCount = weatherViewModel?.cyclingStation.count else { return 0 }
        return cyclingStationCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CyclingStationTableViewCell.identifier) as? CyclingStationTableViewCell,
              let cyclingModel = weatherViewModel?.cyclingStation
        else {
            return UITableViewCell()
        }
        cell.configureCell(with: cyclingModel[indexPath.row])
        return cell
    }
}

extension CyclingStationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentLocation = weatherViewModel?.cyclingStation[indexPath.row]
        guard let latitude = currentLocation?.latitude,
              let longitude = currentLocation?.longitude
        else {
            return
        }
        
        let mapURLString = "http://maps.apple.com/?q=\(latitude),\(longitude)"
        if let mapURL = URL(string: mapURLString) {
            UIApplication.shared.open(mapURL, options: [:], completionHandler: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
