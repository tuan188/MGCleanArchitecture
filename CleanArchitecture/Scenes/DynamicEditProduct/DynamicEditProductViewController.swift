//
// DynamicEditProductViewController.swift
// CleanArchitecture
//
// Created by Tuan Truong on 9/10/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import Reusable

final class DynamicEditProductViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var viewModel: DynamicEditProductViewModel!
    
    private weak var nameTextField: UITextField?
    private weak var priceTextField: UITextField?
    private weak var nameValidationLabel: UILabel?
    private weak var priceValidationLabel: UILabel?
    
    private let dataTrigger = PublishSubject<DynamicEditProductViewModel.DataType>()
    private let endEditTrigger = PublishSubject<Void>()
    private var cells = [DynamicEditProductViewModel.CellType]()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        tableView.do {
            $0.rowHeight = 70
            $0.register(cellType: EditProductNameCell.self)
            $0.register(cellType: EditProductPriceCell.self)
            $0.tableFooterView = UIView()
            $0.keyboardDismissMode = .onDrag
            $0.dataSource = self
        }
    }

    func bindViewModel() {
        let loadTrigger = endEditTrigger.map { DynamicEditProductViewModel.TriggerType.endEditing }
            .asDriverOnErrorJustComplete()
            .startWith(DynamicEditProductViewModel.TriggerType.load)
        
        let input = DynamicEditProductViewModel.Input(
            loadTrigger: loadTrigger,
            updateTrigger: updateButton.rx.tap.asDriver(),
            cancelTrigger: cancelButton.rx.tap.asDriver(),
            dataTrigger: dataTrigger.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input)
        
        output.cancel
            .drive()
            .disposed(by: rx.disposeBag)
        output.cells
            .drive(cellsBinder)
            .disposed(by: rx.disposeBag)
        output.updatedProduct
            .drive()
            .disposed(by: rx.disposeBag)
        output.nameValidation
            .drive(nameValidatorBinder)
            .disposed(by: rx.disposeBag)
        output.priceValidation
            .drive(priceValidatorBinder)
            .disposed(by: rx.disposeBag)
        output.updateEnabled
            .drive(updateButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.loading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Binders
extension DynamicEditProductViewController {
    var nameValidatorBinder: Binder<ValidationResult> {
        return Binder(self) { vc, validation in
            let viewModel = ValidationResultViewModel(validationResult: validation)
            vc.nameTextField?.backgroundColor = viewModel.backgroundColor
            vc.nameValidationLabel?.text = viewModel.text
        }
    }
    
    var priceValidatorBinder: Binder<ValidationResult> {
        return Binder(self) { vc, validation in
            let viewModel = ValidationResultViewModel(validationResult: validation)
            vc.priceTextField?.backgroundColor = viewModel.backgroundColor
            vc.priceValidationLabel?.text = viewModel.text
        }
    }
    
    var cellsBinder: Binder<([DynamicEditProductViewModel.CellType], Bool)> {
        return Binder(self) { vc, args in
            let (cells, needReload) = args
            vc.cells = cells
            if needReload {
                vc.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension DynamicEditProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cells[indexPath.row]
        let viewModel = ValidationResultViewModel(validationResult: cellType.validationResult)
        
        switch cellType.dataType {
        case let .name(name):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EditProductNameCell.self)
                .then {
                    $0.nameTextField.text = name
                    $0.nameTextField.backgroundColor = viewModel.backgroundColor
                    $0.validationLabel.text = viewModel.text
                }
            cell.nameTextField.rx.text.orEmpty
                .subscribe(onNext: { [unowned self] text in
                    self.dataTrigger.onNext(DynamicEditProductViewModel.DataType.name(text))
                })
                .disposed(by: cell.disposeBag)
            cell.nameTextField.rx.controlEvent(UIControl.Event.editingDidEnd)
                .subscribe(onNext: { [unowned self] _ in
                    self.endEditTrigger.onNext(())
                })
                .disposed(by: cell.disposeBag)
            nameTextField = cell.nameTextField
            nameValidationLabel = cell.validationLabel
            return cell
        case let .price(price):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EditProductPriceCell.self)
                .then {
                    $0.priceTextField.text = price
                    $0.priceTextField.backgroundColor = viewModel.backgroundColor
                    $0.validationLabel.text = viewModel.text
                }
            cell.priceTextField.rx.text.orEmpty
                .subscribe(onNext: { [unowned self] text in
                    self.dataTrigger.onNext(DynamicEditProductViewModel.DataType.price(text))
                })
                .disposed(by: cell.disposeBag)
            cell.priceTextField.rx.controlEvent(UIControl.Event.editingDidEnd)
                .subscribe(onNext: { [unowned self] _ in
                    self.endEditTrigger.onNext(())
                })
                .disposed(by: cell.disposeBag)
            priceTextField = cell.priceTextField
            priceValidationLabel = cell.validationLabel
            return cell
        }
    }
}

// MARK: - StoryboardSceneBased
extension DynamicEditProductViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
