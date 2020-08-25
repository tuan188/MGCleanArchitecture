//
//  EditProductViewController.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 6/24/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable
import Validator

final class EditProductViewController: UITableViewController, BindableType {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceValidationLabel: UILabel!

    // MARK: - Properties

    var viewModel: EditProductViewModel!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        logDeinit()
    }
    
    // MARK: - Methods

    func bindViewModel() {
        let input = EditProductViewModel.Input(
            loadTrigger: Driver.just(()),
            nameTrigger: nameTextField.rx.text.orEmpty.asDriver(),
            priceTrigger: priceTextField.rx.text.orEmpty.asDriver(),
            updateTrigger: updateButton.rx.tap
                .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
                .asDriverOnErrorJustComplete(),
            cancelTrigger: cancelButton.rx.tap
                .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
                .asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input)
        
        output.name
            .drive(nameTextField.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.price
            .map { String($0) }
            .drive(priceTextField.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.nameValidation
            .drive(nameValidatorBinder)
            .disposed(by: rx.disposeBag)
        
        output.priceValidation
            .drive(priceValidatorBinder)
            .disposed(by: rx.disposeBag)
        
        output.isUpdateEnabled
            .drive(updateButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        output.updatedProduct
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.cancel
            .drive()
            .disposed(by: rx.disposeBag)
        
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Binders
extension EditProductViewController {
    var nameValidatorBinder: Binder<ValidationResult> {
        return Binder(self) { vc, validation in
            let viewModel = ValidationResultViewModel(validationResult: validation)
            vc.nameTextField.backgroundColor = viewModel.backgroundColor
            vc.nameValidationLabel.text = viewModel.text
        }
    }
    
    var priceValidatorBinder: Binder<ValidationResult> {
        return Binder(self) { vc, validation in
            let viewModel = ValidationResultViewModel(validationResult: validation)
            vc.priceTextField.backgroundColor = viewModel.backgroundColor
            vc.priceValidationLabel.text = viewModel.text
        }
    }
}

// MARK: - StoryboardSceneBased
extension EditProductViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
