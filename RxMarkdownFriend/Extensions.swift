//
//  Extensions.swift
//  SourceDisplay
//
//  Created by JH on 2023/4/22.
//

import Cocoa

extension NSObject {
    static var userInterfaceItemIdentifier: NSUserInterfaceItemIdentifier {
        .init(String(describing: self))
    }
}

extension NSTableView {
    
    func register<CellView: NSView>(_ cellClass: CellView.Type) {
        register(.init(nibClass: cellClass), forIdentifier: CellView.userInterfaceItemIdentifier)
    }
    
    func makeView<CellView: NSView>(withType: CellView.Type, onwer: Any?) -> CellView {
        if let reuseView = makeView(withIdentifier: CellView.userInterfaceItemIdentifier, owner: onwer) as? CellView {
            return reuseView
        } else {
            let cellView = CellView()
            cellView.identifier = CellView.userInterfaceItemIdentifier
            return CellView()
        }
    }
}

extension NSButton {
    func setTarget(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        map { $0[keyPath: keyPath] }
    }
}

extension NSNib {
    convenience init?<View: NSView>(nibClass: View.Type) {
        self.init(nibNamed: .init(describing: nibClass), bundle: .main)
    }
}

extension Int {
    var asString: String {
        "\(self)"
    }
}

extension Optional<Int> {
    var nonNilValue: String {
        self?.asString ?? "nil"
    }
}

extension Optional<String> {
    var nonNilValue: String {
        self ?? "nil"
    }
}

extension String {
    var asNSString: NSString {
        self as NSString
    }
}
