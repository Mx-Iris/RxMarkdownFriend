//
//  CodeBlockViewController.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/28.
//

import AppKit
import RxAppKit
import RxSwift
import RxCocoa

class CodeBlockViewController: ViewController<CodeBlockViewModel>, ViewControllerType {
    override class var nibName: String? { .init(describing: self) }

    @IBOutlet var languagePopUpButton: NSPopUpButton!

    @IBOutlet var formatterPopUpButton: NSPopUpButton!

    @IBOutlet var selectConfigurationFileButton: NSButton!

    @IBOutlet var selectedConfigurationPathField: NSTextField!

    @IBOutlet var commitButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setup() {
        super.setup()
    }

    override func bind() {
        super.bind()
        viewModel.supportedLanguageStrings.drive(languagePopUpButton.rx.items).disposed(by: disposeBag)
        viewModel.supportedFormatterStrings.drive(formatterPopUpButton.rx.items).disposed(by: disposeBag)
        
        let commit = commitButton.rx.click
        let input = ViewModel.Input(
            changeFormatter: formatterPopUpButton.rx.selectedItem.asObservable(),
            selectFormatterConfigFile: selectConfigurationFileButton.rx.click.skip(1),
            commit: commit.skip(1)
        )
        let output = viewModel.transform(input)

        output.selectedConfigFileURL.asDriver(onErrorJustReturn: nil).map { $0?.path ?? "" }.drive(selectedConfigurationPathField.rx.stringValue).disposed(by: disposeBag)
    }
}
