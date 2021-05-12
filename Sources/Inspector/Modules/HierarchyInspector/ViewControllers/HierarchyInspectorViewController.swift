//  Copyright (c) 2021 Pedro Almeida
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import UIKeyCommandTableView
import UIKeyboardAnimatable
#if swift(>=5.3)
import GameController
#endif

protocol HierarchyInspectorViewControllerDelegate: AnyObject {
    func hierarchyInspectorViewController(_ viewController: HierarchyInspectorViewController,
                                          didSelect command: HierarchyInspectorCommand?)
    
    func hierarchyInspectorViewControllerDidFinish(_ viewController: HierarchyInspectorViewController)
}

final class HierarchyInspectorViewController: UIViewController, KeyboardAnimatable {

    static func create(viewModel: HierarchyInspectorViewModelProtocol) -> HierarchyInspectorViewController {
        let viewController = HierarchyInspectorViewController()
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    // MARK: - Properties
    
    weak var delegate: HierarchyInspectorViewControllerDelegate?
    
    private(set) var viewModel: HierarchyInspectorViewModelProtocol!
    
    private(set) lazy var viewCode = HierarchyInspectorView().then {
        $0.delegate = self
        
        $0.searchView.textField.addTarget(self, action: #selector(search), for: .editingChanged)
        $0.searchView.textField.delegate = self
        
        $0.tableView.addObserver(self, forKeyPath: .contentSize, options: .new, context: nil)
        
        $0.tableView.register(InspectorActionCell.self)
        $0.tableView.register(InspectorElementReferenceCell.self)
        $0.tableView.registerHeaderFooter(HierarchyInspectorHeaderView.self)
        
        $0.tableView.delegate = self
        $0.tableView.dataSource = self
        $0.tableView.keyCommandsDelegate = self
    }
    
    private var needsSetup = true
    
    private var isFinishing = false
    
    private var shouldToggleFirstResponderOnAppear: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        
        #if swift(>=5.3)
        if #available(iOS 14.0, *) {
            return GCKeyboard.coalesced != nil
        }
        #endif
        
        return false
        #endif
    }
    
    override func loadView() {
        view = viewCode
    }
    
    deinit {
        if isViewLoaded {
            viewCode.tableView.removeObserver(self, forKeyPath: .contentSize, context: nil)
        }
    }
    
    @objc
    func toggleResponderAndSelectLastRow() {
        toggleFirstResponder()
        
        if viewCode.tableView.isFirstResponder {
            viewCode.tableView.selectRowIfPossible(at: viewCode.tableView.indexPathForLastRowInLastSection)
        }
    }
    
    @objc
    func toggleResponderAndSelectFirstRow() {
        toggleFirstResponder()
        
        if viewCode.tableView.isFirstResponder {
            viewCode.tableView.selectRowIfPossible(at: IndexPath(item: .zero, section: .zero))
        }
    }
    
    @objc
    func toggleFirstResponder() {
        switch viewCode.searchView.isFirstResponder {
        case true:
            viewCode.searchView.resignFirstResponder()
            viewCode.tableView.becomeFirstResponder()
        
        case false:
            viewCode.tableView.resignFirstResponder()
            viewCode.searchView.becomeFirstResponder()
        }
    }
    
    // MARK: - Overrides
    
    private lazy var searchKeyCommands: [UIKeyCommand] = {
        var keyCommands = CharacterSet.urlQueryAllowed.allCharacters().map {
            UIKeyCommand(.key($0), action: #selector(type))
        }
        
        keyCommands.append(
            UIKeyCommand(.backspace, action: #selector(backspaceKey))
        )
        
        return keyCommands
    }()
    
    private func addSearchKeyCommandListeners() {
        searchKeyCommands.forEach { addKeyCommand($0) }
    }
    private func removeSearchKeyCommandListeners() {
        searchKeyCommands.forEach { removeKeyCommand($0) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // key commands
        addKeyCommand(dismissModalKeyCommand(action: #selector(finish)))
        addKeyCommand(UIKeyCommand(.tab,       action: #selector(toggleResponderAndSelectFirstRow)))
        addKeyCommand(UIKeyCommand(.arrowDown, action: #selector(toggleResponderAndSelectFirstRow)))
        addKeyCommand(UIKeyCommand(.arrowUp,   action: #selector(toggleResponderAndSelectLastRow)))
        addKeyCommand(
            UIKeyCommand(
                .discoverabilityTitle(
                    title: Texts.dismissView,
                    key: Inspector.configuration.keyCommands.presentationOptions
                ),
                action: #selector(finish)
            )
        )
        
        // keyboard event handlers
        animateWhenKeyboard(.willHide) { _ in
            self.viewCode.keyboardFrame = nil
            self.viewCode.layoutIfNeeded()
        }
        
        animateWhenKeyboard(.willShow) { info in
            Console.log(info)
            self.viewCode.keyboardFrame = info.keyboardFrame
            self.viewCode.layoutIfNeeded()
        }
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard
            keyPath == .contentSize,
            let contentSize = change?[.newKey] as? CGSize
        else {
            return
        }
        
        viewCode.tableViewContentSize = contentSize
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard needsSetup else {
            return
        }
        
        needsSetup = false
        
        if animated {
            viewCode.animate(.in)
        }
        
        reloadData()
        
        guard shouldToggleFirstResponderOnAppear else {
            return
        }
        
        DispatchQueue.main.async {
            self.toggleFirstResponder()
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        isFinishing = true
        view.endEditing(true)
        
        super.dismiss(animated: flag, completion: completion)
        
        if flag  {
            viewCode.animate(.out)
        }
    }
    
    // MARK: - Private Methods
    
    private func reloadData() {
        viewModel.loadData()
        
        viewCode.searchView.separatorView.isSafelyHidden = viewModel.isEmpty
        
        viewCode.tableView.isSafelyHidden = viewModel.isEmpty
                
        viewCode.tableView.reloadData()
    }
    
}

// MARK: - Keyboard Handlers

@objc private extension HierarchyInspectorViewController {
    
    func type(_ sender: Any) {
        guard
            let keyCommand = sender as? UIKeyCommand,
            let keyCommandInput = keyCommand.input
        else {
            return
        }
        
        let character: String = {
            switch keyCommand.modifierFlags {
            case .alphaShift:
                return keyCommandInput
                
            default:
                return keyCommandInput.lowercased()
            }
        }()
        
        viewCode.searchView.insertText(character)
        search()
    }
    
    func backspaceKey() {
        viewCode.searchView.deleteBackward()
        search()
    }
    
    func search() {
        viewCode.searchView.becomeFirstResponder()
        viewModel.searchQuery = viewCode.searchView.query
        reloadData()
        
        DispatchQueue.main.async {
            self.viewCode.tableView.scrollToRow(
                at: IndexPath(
                    row: NSNotFound,
                    section: .zero
                ),
                at: .top,
                animated: false
            )
        }
    }
    
    func finish() {
        isFinishing = true
        view.endEditing(true)
        delegate?.hierarchyInspectorViewControllerDidFinish(self)
    }
}

// MARK: - HierarchyInspectorViewDelegate

extension HierarchyInspectorViewController: HierarchyInspectorViewDelegate {
    func hierarchyInspectorViewDidTapOutside(_ view: HierarchyInspectorView) {
        delegate?.hierarchyInspectorViewControllerDidFinish(self)
    }
}

fileprivate extension String {
    static let contentSize = "contentSize"
}

extension HierarchyInspectorViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if string == UIKeyCommand.inputTab {
            DispatchQueue.main.async {
                self.toggleFirstResponder()
            }
            return false
        }
        return true
    }
}

// MARK: - UITableViewKeyCommandsDelegate

extension HierarchyInspectorViewController: UITableViewKeyCommandsDelegate {
    func tableViewDidBecomeFirstResponder(_ tableView: UIKeyCommandTableView) {
        addSearchKeyCommandListeners()
    }
    
    func tableViewDidResignFirstResponder(_ tableView: UIKeyCommandTableView) {
        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: false) }
        removeSearchKeyCommandListeners()
        
        guard isFinishing == false else { return }
        
        viewCode.searchView.becomeFirstResponder()
    }
    
    func tableViewKeyCommandSelectionBelowBounds(_ tableView: UIKeyCommandTableView) -> UIKeyCommandTableView.OutOfBoundsBehavior {
        .resignFirstResponder
    }
    
    func tableViewKeyCommandSelectionAboveBounds(_ tableView: UIKeyCommandTableView) -> UIKeyCommandTableView.OutOfBoundsBehavior {
        .resignFirstResponder
    }
    
}
