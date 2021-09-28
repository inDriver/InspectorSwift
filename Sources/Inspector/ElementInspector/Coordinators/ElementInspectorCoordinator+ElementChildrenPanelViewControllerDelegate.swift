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

extension ElementInspectorCoordinator: ElementChildrenPanelViewControllerDelegate {
    func elementChildrenPanelViewController(_ viewController: ElementChildrenPanelViewController,
                                            didSelect reference: ViewHierarchyReference,
                                            with action: ViewHierarchyAction,
                                            from fromReference: ViewHierarchyReference)
    {
        guard canPerform(action: action) else {
            delegate?.perform(action: action, with: reference, from: .none)
            return
        }

        guard let panel = ElementInspectorPanel(rawValue: action) else { return }

        if reference == fromReference {
            topElementInspectorViewController?.selectPanelIfAvailable(panel)
            return
        }

        operationQueue.cancelAllOperations()

        let pushOperation = MainThreadOperation(name: "Push \(reference.displayName)") { [weak self] in
            guard let self = self else { return }

            let elementInspectorViewController = Self.makeElementInspectorViewController(
                with: reference,
                elementLibraries: self.snapshot.elementLibraries,
                selectedPanel: panel,
                delegate: self,
                in: self.snapshot
            )

            self.navigationController.pushViewController(elementInspectorViewController, animated: true)
        }

        addOperationToQueue(pushOperation)
    }
}
