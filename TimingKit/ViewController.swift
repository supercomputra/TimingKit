//
//  ViewController.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import UIKit
import WidgetKit


class TimingsTableViewController: UITableViewController {
    
    var result: TimingsResult {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    var currentEditingCorrectionTimingType: TimingType?
    
    required init() {
        result = Timings().timings(for: Date())
        
        super.init(style: .insetGrouped)
        title = "TimingKit"
        
        // Observer preferences update
        NotificationCenter.default.addObserver(self, selector: #selector(onPreferencesDidUpdate), name: .didUpdatePreferences, object: nil)
        
    }
    
    func reloadTimings() {
        result =  Timings().timings(for: Date())
    }
    
    @objc
    func onPreferencesDidUpdate() {
        WidgetCenter.shared.reloadAllTimelines()
        reloadTimings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimingType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Calculation Corrections"
        case 1:
            return "Today"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let timingType: TimingType = TimingType(rawValue: indexPath.row)!
        switch indexPath.section {
        case 0:
            var contentConfiguration: UIListContentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = timingType.description
            contentConfiguration.secondaryText = correctionLocalizedDescription(for: timingType)
            cell.contentConfiguration = contentConfiguration
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
        case 1:
            var contentConfiguration: UIListContentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.image = timingType.image
            contentConfiguration.text = timingType.description
            contentConfiguration.secondaryText = result.timing(for: timingType).timeDescription
            cell.contentConfiguration = contentConfiguration
            cell.selectionStyle = .none
            cell.accessoryType = .none
        default:
            fatalError()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let type: TimingType = TimingType(rawValue: indexPath.row)!
            currentEditingCorrectionTimingType = type
            let controller: PickerViewController = correctionPikcerViewController(for: type)
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        default:
            return
        }
    }
    
    private func correctionLocalizedDescription(for type: TimingType) -> String? {
        let format: String = NSLocalizedString("%@ Minutes" , comment: "")
        let timingAdjustment: Int = Preferences.shared.correction(for: type)
        if timingAdjustment > 0 {
            return String(format: format, String(format: "+%d", timingAdjustment))
        } else if timingAdjustment < 0 {
            return  String(format: format, String(format: "%d", timingAdjustment))
        } else {
            return nil
        }
    }
    
    private func correctionPikcerViewController(for type: TimingType) -> PickerViewController {
        let correction: Int = Preferences.shared.correction(for: type)
        var selectedIndex: Int = 0
        var currentIndex: Int = 0
        var models: [PickerViewModel.Model] = []
        for value in stride(from: -120.0, through: 120.0, by: 1.0) {
            let format: String = NSLocalizedString("%@ Minutes" , comment: "")
            var title: String
            if value <= 0 {
                title = String(format: format, "\(Int(value))")
            } else {
                title = String(format: format, "+\(Int(value))")
            }
            
            if correction == Int(value) {
                selectedIndex = currentIndex
            }
            
            let model: PickerViewModel.Model = PickerViewModel.Model(title: title, value: value)
            models.append(model)
            currentIndex += 1
        }
        
        let viewModel: PickerViewModel = PickerViewModel(title: type.description, headerTitle: NSLocalizedString("Time Correction", comment: ""), footerTitle: nil, models: models, selectedIndex: selectedIndex)
        return PickerViewController(viewModel: viewModel)
    }
}

extension TimingsTableViewController: PickerViewControllerDelegate {
    func pickerViewController(_ controller: PickerViewController, didSelectPickerViewComponentForItem item: PickerViewModel.Model, atIndex index: Int) {
        guard let type: TimingType = currentEditingCorrectionTimingType else { return }
        let cleanedValue: Int = Int(item.value)
        Preferences.shared.setCorrection(cleanedValue, for: type)
    }
}

extension TimingType {
    fileprivate var image: UIImage {
        switch self {
        case .fajr:
            return UIImage(systemName: "light.max")!
        case .dhuhr:
            return UIImage(systemName: "sun.min")!
        case .asr:
            return UIImage(systemName: "sunset")!
        case .maghrib:
            return UIImage(systemName: "sunset.fill")!
        case .isha:
            return UIImage(systemName: "moon")!
        }
    }
}
