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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate weak var nameTextField: UITextField?
    fileprivate weak var priceTextField: UITextField?
    fileprivate weak var nameValidationLabel: UILabel?
    fileprivate weak var priceValidationLabel: UILabel?
    
    var viewModel: DynamicEditProductViewModel!
    
    fileprivate let dataTrigger = PublishSubject<DynamicEditProductViewModel.DataType>()
    fileprivate let endEditTrigger = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        tableView.do {
            $0.rowHeight = 70
            $0.register(cellType: EditProductNameCell.self)
            $0.register(cellType: EditProductPriceCell.self)
            $0.tableFooterView = UIView()
            $0.keyboardDismissMode = .onDrag
        }
    }

    deinit {
        logDeinit()
    }

    func bindViewModel() {
        let loadTrigger = endEditTrigger
            .asDriverOnErrorJustComplete()
            .startWith(())
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
            .drive(tableView.rx.items) { [weak self] tableView, index, cellType in
                let indexPath = IndexPath(row: index, section: 0)
                let viewModel = ValidationResultViewModel(validationResult: cellType.validationResult)
                switch cellType.dataType {
                case let .name(name):
                    let cell = tableView.dequeueReusableCell(
                        for: indexPath,
                        cellType: EditProductNameCell.self).then {
                            $0.nameTextField.text = name
                            $0.nameTextField.backgroundColor = viewModel.backgroundColor
                            $0.validationLabel.text = viewModel.text
                            
                    }
                    cell.nameTextField.rx.text.orEmpty
                        .subscribe(onNext: { text in
                            self?.dataTrigger.onNext(DynamicEditProductViewModel.DataType.name(text))
                        })
                        .disposed(by: cell.rx.disposeBag)
                    cell.nameTextField.rx.controlEvent(UIControlEvents.editingDidEnd)
                        .subscribe(onNext: { _ in
                            self?.endEditTrigger.onNext(())
                        })
                        .disposed(by: cell.rx.disposeBag)
                    self?.nameTextField = cell.nameTextField
                    self?.nameValidationLabel = cell.validationLabel
                    return cell
                case let .price(price):
                    let cell = tableView.dequeueReusableCell(
                        for: indexPath,
                        cellType: EditProductPriceCell.self).then {
                            $0.priceTextField.text = price
                            $0.priceTextField.backgroundColor = viewModel.backgroundColor
                            $0.validationLabel.text = viewModel.text
                    }
                    cell.priceTextField.rx.text.orEmpty
                        .subscribe(onNext: { text in
                            self?.dataTrigger.onNext(DynamicEditProductViewModel.DataType.price(text))
                        })
                        .disposed(by: cell.rx.disposeBag)
                    cell.priceTextField.rx.controlEvent(UIControlEvents.editingDidEnd)
                        .subscribe(onNext: { _ in
                            self?.endEditTrigger.onNext(())
                        })
                        .disposed(by: cell.rx.disposeBag)
                    self?.priceTextField = cell.priceTextField
                    self?.priceValidationLabel = cell.validationLabel
                    return cell
                }
            }
            .disposed(by: rx.disposeBag)
        output.updatedProduct
            .drive()
            .disposed(by: rx.disposeBag)
        output.nameValidation
            .drive(nameValidatorBinding)
            .disposed(by: rx.disposeBag)
        output.priceValidation
            .drive(priceValidatorBinding)
            .disposed(by: rx.disposeBag)
        output.updateEnable
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

extension DynamicEditProductViewController {
    var nameValidatorBinding: Binder<ValidationResult> {
        return Binder(self) { vc, validation in
            let viewModel = ValidationResultViewModel(validationResult: validation)
            vc.nameTextField?.backgroundColor = viewModel.backgroundColor
            vc.nameValidationLabel?.text = viewModel.text
        }
    }
    
    var priceValidatorBinding: Binder<ValidationResult> {
        return Binder(self) { vc, validation in
            let viewModel = ValidationResultViewModel(validationResult: validation)
            vc.priceTextField?.backgroundColor = viewModel.backgroundColor
            vc.priceValidationLabel?.text = viewModel.text
        }
    }
}

// MARK: - StoryboardSceneBased
extension DynamicEditProductViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
