//
//  MainWindowController.swift
//  MarkdownFormat
//
//  Created by JH on 2023/5/21.
//

import AppKit
import RxSwift
import RxCocoa
import UniformTypeIdentifiers

class MarkdownFileProvider {
    let openedMarkdownFile: BehaviorSubject<URL?> = .init(value: nil)
    let commitedMarkdownString: BehaviorSubject<String?> = .init(value: nil)
}

class MainWindowController: NSWindowController, NSWindowDelegate, NSToolbarItemValidation {
    let provider: MarkdownFileProvider = .init()
    let disposeBag = DisposeBag()
    lazy var splitViewController: MainSplitViewController = .init(provider: provider)

    convenience init() {
        self.init(windowNibName: "")
    }

    override func loadWindow() {
        window = NSWindow(contentViewController: splitViewController).then {
            $0.styleMask.insert(.fullSizeContentView)
            $0.delegate = self
            $0.title = "Markdown Friend"
            $0.setFrameAutosaveName("MainWindow.AutoSaveName")
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.toolbar = NSToolbar().then {
            $0.delegate = self
            $0.displayMode = .iconOnly
            $0.allowsUserCustomization = false
        }
    }

    func windowDidBecomeMain(_ notification: Notification) {
        window?.positionCenter()
    }
}

extension MainWindowController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.sidebar, .documentPath, .addDocument, .export, .sidebarTrackingSeparator, .space, .flexibleSpace]
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.sidebar, .sidebarTrackingSeparator, .documentPath, .space, .addDocument, .export]
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .sidebar:
            return NSToolbarItem(itemIdentifier: itemIdentifier).then {
                $0.image = .init(systemSymbolName: "sidebar.left", accessibilityDescription: nil)
                $0.action = #selector(MainSplitViewController.toggleSidebar(_:))
            }
        case .documentPath:
            return NSToolbarItem(itemIdentifier: itemIdentifier).then {
                $0.view = NSPathControl().then {
                    $0.isEditable = false
                    provider.openedMarkdownFile.asDriver(onErrorJustReturn: .homeDirectory).drive($0.rx.url).disposed(by: disposeBag)
                    $0.frame.size = .init(width: 200, height: 30)
                }
            }
        case .addDocument:
            return NSToolbarItem(itemIdentifier: itemIdentifier).then {
                $0.image = .init(systemSymbolName: "plus", accessibilityDescription: nil)
                $0.target = self
                $0.action = #selector(addDocumentAction(_:))
            }
        case .export:
            return NSToolbarItem(itemIdentifier: itemIdentifier).then {
                $0.image = .init(systemSymbolName: "square.and.arrow.up", accessibilityDescription: nil)
                $0.target = self
                $0.action = #selector(exportDocumentAction(_:))
                provider.openedMarkdownFile.map { $0 != nil }.asDriver(onErrorJustReturn: false).drive($0.rx.isEnabled).disposed(by: disposeBag)
            }
        default:
            return nil
        }
    }

    @objc
    func addDocumentAction(_ item: NSToolbarItem) {
        NSOpenPanel().do { openPanel in
            openPanel.allowedContentTypes = [.markdown]
            openPanel.allowsMultipleSelection = false
            openPanel.canChooseFiles = true
            openPanel.canChooseDirectories = false
            openPanel.begin { [weak self] result in
                guard result == .OK, let url = openPanel.url, let self = self else { return }
                self.provider.openedMarkdownFile.on(.next(url))
            }
        }
    }

    @objc
    func exportDocumentAction(_ item: NSToolbarItem) {
        NSSavePanel().then {
            $0.allowedContentTypes = [.markdown]
            $0.canCreateDirectories = true
            $0.allowsOtherFileTypes = false
        }.rx.begin()
            .filter { $0.result == .OK }.compactMap { $0.panel.url }
            .asObservable()
            .withLatestFrom(provider.commitedMarkdownString.compactMap { $0 }) { saveURL, commitedMarkdownString -> Bool in
                do {
                    try commitedMarkdownString.write(to: saveURL, atomically: true, encoding: .utf8)
                    return true
                } catch {
                    return false
                }
            }
            .asObservable()
            .subscribe(onNext: { isSuccess in
                print(isSuccess)
            })
            .disposed(by: disposeBag)
    }
    
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        item.isEnabled
    }
    
}

extension NSToolbarItem.Identifier {
    static let documentPath = NSToolbarItem.Identifier("documentPath")
    static let addDocument = NSToolbarItem.Identifier("addDocument")
    static let sidebar = NSToolbarItem.Identifier("Sidebar")
    static let export = NSToolbarItem.Identifier("Export")
}

public extension NSWindow {
    /// Positions the `NSWindow` at the horizontal-vertical center of the `visibleFrame` (takes Status Bar and Dock sizes into account)
    func positionCenter() {
        if let screenSize = screen?.visibleFrame.size {
            setFrameOrigin(NSPoint(x: (screenSize.width - frame.size.width) / 2, y: (screenSize.height - frame.size.height) / 2))
        }
    }

    /// Centers the window within the `visibleFrame`, and sizes it with the width-by-height dimensions provided.
    func setCenterFrame(width: Int, height: Int) {
        if let screenSize = screen?.visibleFrame.size {
            let x = (screenSize.width - frame.size.width) / 2
            let y = (screenSize.height - frame.size.height) / 2
            setFrame(NSRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height)), display: true)
        }
    }

    /// Returns the center x-point of the `screen.visibleFrame` (the frame between the Status Bar and Dock).
    /// Falls back on `screen.frame` when `.visibleFrame` is unavailable (includes Status Bar and Dock).
    func xCenter() -> CGFloat {
        if let screenSize = screen?.visibleFrame.size { return (screenSize.width - frame.size.width) / 2 }
        if let screenSize = screen?.frame.size { return (screenSize.width - frame.size.width) / 2 }
        return CGFloat(0)
    }

    /// Returns the center y-point of the `screen.visibleFrame` (the frame between the Status Bar and Dock).
    /// Falls back on `screen.frame` when `.visibleFrame` is unavailable (includes Status Bar and Dock).
    func yCenter() -> CGFloat {
        if let screenSize = screen?.visibleFrame.size { return (screenSize.height - frame.size.height) / 2 }
        if let screenSize = screen?.frame.size { return (screenSize.height - frame.size.height) / 2 }
        return CGFloat(0)
    }
}

extension UTType {
    static let markdown = UTType(filenameExtension: "md")!
}
