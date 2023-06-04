//
//  ViewController.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/24.
//

import AppKit
import RxSwift

class ViewController<ViewModel: ViewModelType>: NSViewController {
    let viewModel: ViewModel

    let disposeBag = DisposeBag()

    let loadFromNib: Bool
    
    class var nibName: String? { nil }
    
    override func loadView() {
        if loadFromNib {
            super.loadView()
        } else {
            view = NSView()
        }
    }
    
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.loadFromNib = Self.nibName != nil
        super.init(nibName: Self.nibName, bundle: nil)
    }

    required init?(coder: NSCoder, viewModel: ViewModel) {
        self.viewModel = viewModel
        self.loadFromNib = true
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        bind()
    }

    func setup() {}

    func layout() {}

    func bind() {}
}
