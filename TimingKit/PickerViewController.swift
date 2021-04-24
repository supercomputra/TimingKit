//
//  PickerViewController.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import UIKit


final class PickerViewController: UITableViewController {
    
    let viewModel: PickerViewModel
    
    weak var delegate: PickerViewControllerDelegate?
    
    required init(viewModel: PickerViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
        self.navigationItem.title = viewModel.title
        self.navigationItem.largeTitleDisplayMode = .never
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GenericTableViewCell<PickerView>.self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitle
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.footerTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GenericTableViewCell<PickerView> = tableView.dequeueReusableCell(for: indexPath)
        cell.view.pickerView.delegate = self
        cell.view.pickerView.dataSource = self
        cell.view.pickerView.selectRow(viewModel.selectedIndex, inComponent: 0, animated: true)
        return cell
    }
}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.onViewDidSelectPickerView(at: row, component: component)
    }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfPickerViewComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsInPickerViewComponent(component)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titleForPickerView(at: row, component: component)
    }
}

protocol PickerViewControllerDelegate: AnyObject {
    func pickerViewController(_ controller: PickerViewController, didSelectPickerViewComponentForItem item: PickerViewModel.Model, atIndex index: Int)
}

final class PickerView: UIView {
    private(set) lazy var pickerView: UIPickerView = {
        let view: UIPickerView = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PickerViewController: PickerViewModelDelegate {
    func viewModel(_ viewModel: PickerViewModel, didSelectPickerViewComponentForItem item: PickerViewModel.Model, atIndex index: Int) {
        delegate?.pickerViewController(self, didSelectPickerViewComponentForItem: item, atIndex: index)
    }
}
    
final class PickerViewModel {
    struct Model {
        let title: String
        let value: Double
    }
    
    private var models: [Model]
    
    let title: String
    
    let headerTitle: String?
    
    let footerTitle: String?
    
    let selectedIndex: Int
    
    weak var delegate: PickerViewModelDelegate?
    
    init(title: String, headerTitle: String? = nil, footerTitle: String? = nil, models: [Model] = [], selectedIndex: Int) {
        self.title = title
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.models = models
        self.selectedIndex = selectedIndex
    }
    
    func numberOfPickerViewComponents() -> Int {
        return 1
    }
    
    func numberOfRowsInPickerViewComponent(_ component: Int) -> Int {
        return models.count
    }
    
    func titleForPickerView(at row: Int, component: Int) -> String? {
        return models[row].title
    }
    
    func onViewDidSelectPickerView(at row: Int, component: Int) {
        delegate?.viewModel(self, didSelectPickerViewComponentForItem: models[row], atIndex: row)
    }
}

protocol PickerViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: PickerViewModel, didSelectPickerViewComponentForItem item: PickerViewModel.Model, atIndex index: Int)
}
