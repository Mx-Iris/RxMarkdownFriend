//
//  SidebarViewController.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/21.
//

import AppKit
import RxSwift
import RxCocoa
import RxAppKit

class SidebarViewController: ViewController<SidebarViewModel>, ViewControllerType {

    let tableView: NSTableView = .init()
    
    let scrollView: NSScrollView = .init()
    
    override func loadView() {
        view = scrollView
    }

    override func setup() {
        super.setup()
        
        scrollView.do {
            $0.hasVerticalScroller = false
            $0.documentView = tableView
        }

        tableView.do {
            $0.headerView = nil
            $0.addTableColumn(NSTableColumn())
            $0.wantsLayer = true
            $0.backgroundColor = .clear
            $0.rowHeight = 50
            $0.style = .inset
        }
    }

    override func bind() {
        super.bind()
        let output = viewModel.transform(.init())

        output.items.bind(to: tableView.rx.items(_:)) { [weak self] tableView, tableColumn, row, item in
            guard let self = self else { return nil }
            let cellView = tableView.makeView(withType: SidebarCellView.self, onwer: self)
            cellView.titleLabel.stringValue = item
            return cellView
        }.disposed(by: disposeBag)

        tableView.rx.didClick.subscribe(with: self) { target, index in
            target.viewModel.selectedIndex.on(.next(index.row))
        }.disposed(by: disposeBag)
    }
}
