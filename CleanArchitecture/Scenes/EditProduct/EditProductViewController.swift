//
// EditProductViewController.swift
// CleanArchitecture
//
// Created by Tuan Truong on 6/24/18.
// Copyright © 2018 Framgia. All rights reserved.
//

import UIKit
import Reusable

final class EditProductViewController: UITableViewController, BindableType {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!

    var viewModel: EditProductViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        logDeinit()
    }

    func bindViewModel() {
        let input = EditProductViewModel.Input(
            loadTrigger: Driver.just(()),
            nameTrigger: nameTextField.rx.text.orEmpty.asDriver(),
            priceTrigger: priceTextField.rx.text.orEmpty.asDriver(),
            updateTrigger: updateButton.rx.tap
                .throttle(0.5, scheduler: MainScheduler.instance)
                .asDriverOnErrorJustComplete(),
            cancelTrigger: cancelButton.rx.tap
                .throttle(0.5, scheduler: MainScheduler.instance)
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
            .drive(nameValidatorBinding)
            .disposed(by: rx.disposeBag)
        output.priceValidation
            .drive(priceValidatorBinding)
            .disposed(by: rx.disposeBag)
        output.updateEnable
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
        output.loading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
    }

}

extension EditProductViewController {
    var nameValidatorBinding: Binder<ValidationResult> {
        return Binder(self) { vc, validation in
            if validation.isValid {
                vc.nameTextField.backgroundColor = UIColor.white
            } else {
                vc.nameTextField.backgroundColor = UIColor.yellow
            }
        }
    }
    
    var priceValidatorBinding: Binder<ValidationResult> {
        return Binder(self) { vc, validation in
            if validation.isValid {
                vc.priceTextField.backgroundColor = UIColor.white
            } else {
                vc.priceTextField.backgroundColor = UIColor.yellow
            }
        }
    }
}

// MARK: - StoryboardSceneBased
extension EditProductViewController: StoryboardSceneBased {
    // TODO: - Update storyboard
    static var sceneStoryboard = Storyboards.product
}
