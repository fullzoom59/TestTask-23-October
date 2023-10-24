import UIKit

class CyclingStationTableViewCell: UITableViewCell {
    static let identifier = "CyclingStationTableViewCell"
    
    private lazy var bikeNameLabel = UILabel(title: "Julius-Raab-Platz", font: .boldSystemFont(ofSize: 15))
    private lazy var cyclingCountLabel = UILabel(title: "12 bikes",titleColor: .yellow)
    private lazy var emptySlotsLabel = UILabel(title: "0 slots", textAligment: .right, titleColor: .yellow)
    private lazy var latitudeLabel = UILabel(title: "15.43242", textAligment: .right, font: .italicSystemFont(ofSize: 10))
    private lazy var longitudeLabel = UILabel(title: "56.42342",textAligment: .right, font: .italicSystemFont(ofSize: 10))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(bikeNameLabel, cyclingCountLabel, emptySlotsLabel, latitudeLabel, longitudeLabel)
        NSLayoutConstraint.activate([
            bikeNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            bikeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            bikeNameLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            cyclingCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            cyclingCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            emptySlotsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            emptySlotsLabel.leadingAnchor.constraint(equalTo: cyclingCountLabel.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            latitudeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            latitudeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 5),
            longitudeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    public func configureCell(with model: Station) {
        bikeNameLabel.text = model.name
        cyclingCountLabel.text = "\(model.free_bikes) bikes"
        emptySlotsLabel.text = "\(model.empty_slots ?? 0) slots"
        latitudeLabel.text = "\(model.latitude)"
        longitudeLabel.text = "\(model.longitude)"
    }
}
