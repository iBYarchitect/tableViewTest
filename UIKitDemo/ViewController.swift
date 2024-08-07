//
//  ViewController.swift
//  UIKitDemo
//
//  Created by Alex Zavadskiy on 6.08.24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let expandButton = UIButton(type: .system)
    var isTableViewExpanded = false

    private lazy var fullFeaturesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = true
        tableView.register(
            CardViewFullFeaturesTableViewCell.self,
            forCellReuseIdentifier: "CardViewFullFeaturesTableViewCell"
        )
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        expandButton.setTitle("Expand/Collapse", for: .normal)
        expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        view.addSubview(expandButton)

        view.addSubview(fullFeaturesTableView)

        expandButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }

        fullFeaturesTableView.snp.makeConstraints { make in
            make.top.equalTo(expandButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
    }

    @objc func expandButtonTapped() {
        toggleTableView()
    }

    func toggleTableView() {
        isTableViewExpanded.toggle()

        let newHeight = isTableViewExpanded ? fullFeaturesTableView.contentSize.height : 0

        self.fullFeaturesTableView.snp.updateConstraints { make in
            make.height.equalTo(newHeight)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView == fullFeaturesTableView else { return 0 }
        return fullFeaturesCellsVM.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView == fullFeaturesTableView else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "CardViewFullFeaturesTableViewCell", for: indexPath) as! CardViewFullFeaturesTableViewCell
        let viewModel = fullFeaturesCellsVM[indexPath.row]
        cell.configureCell(with: viewModel)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

public struct CardViewFullFeaturesViewModel {
    let title: String
    let features: [String]

    public init(title: String, features: [String]) {
        self.title = title
        self.features = features
    }
}

// MARK: - Model
public let fullFeaturesCellsVM: [CardViewFullFeaturesViewModel] = [
    CardViewFullFeaturesViewModel(
        title: "Patient Management",
        features: [
            "Add patients",
            "Edit patients",
            "Delete patients",
            "Track medical history / patient records",
            "Edit medical history",
            "Delete medical history",
        ]
    ),
    CardViewFullFeaturesViewModel(
        title: "Staff Schedule Management",
        features: [
            "Manage own schedule",
            "Manage staff schedule",
            "Schedule an appointment",
            "Schedule an appointment for staff",
            "View personal availability",
            "See staff availability",
            "Staff vacation approval",
            "Receive reminders",
        ]
    ),
    CardViewFullFeaturesViewModel(
        title: "Financial management",
        features: [
            "Generate and manage invoices, bills and receipts",
            "Track payments",
            "Generate financial reports",
            "Manage staff extra work",
            "Assign staff payments",
        ]
    ),
    CardViewFullFeaturesViewModel(
        title: "Communication with Patients",
        features: [
            "Communicate online with patients via a third party system",
            "Send test results and follow-up instructions to patients (e-mail)",
        ]
    ),
    CardViewFullFeaturesViewModel(
        title: "Inventory management",
        features: [
            "Track medical supplies and medication stock levels",
        ]
    ),
    CardViewFullFeaturesViewModel(
        title: "Facility management",
        features: [
            "See room allocations",
            "Schedule maintenance (cleaning)",
            "Control room booking",
        ]
    )
]

// MARK: - CardViewFullFeaturesTableViewCell+Model

public final class CardViewFullFeaturesTableViewCell: UITableViewCell {
    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .blue
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    public func configureCell(with model: CardViewFullFeaturesViewModel) {
        titleLabel.text = model.title

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, feature) in model.features.enumerated() {
            let featureLabel = UILabel()
            featureLabel.text = "\(index + 1). \(feature)"
            featureLabel.font = UIFont.systemFont(ofSize: 14)
            featureLabel.textColor = .darkGray
            stackView.addArrangedSubview(featureLabel)
        }

        stackView.addArrangedSubview(bottomDivider)
    }

    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        setConstraints()
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }

        bottomDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}
