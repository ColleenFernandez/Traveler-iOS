//
//  TableViewExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//
import UIKit

public extension UITableView {
    
//    func registerCellClass(_ cellClass: AnyClass) {
//        let identifier = String.className(cellClass)
//        self.register(cellClass, forCellReuseIdentifier: identifier)
//    }
//    
//    func registerCellNib(_ cellClass: AnyClass) {
//        let identifier = String.className(cellClass)
//        let nib = UINib(nibName: identifier, bundle: nil)
//        self.register(nib, forCellReuseIdentifier: identifier)
//    }
//    
//    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
//        let identifier = String.className(viewClass)
//        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
//    }
//    
//    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
//        let identifier = String.className(viewClass)
//        let nib = UINib(nibName: identifier, bundle: nil)
//        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
//    }
    
    func scroll(to: Position, animated: Bool) {
      let sections = numberOfSections
      let rows = numberOfRows(inSection: numberOfSections - 1)
      switch to {
      case .top:
        if rows > 0 {
          let indexPath = IndexPath(row: 0, section: 0)
          self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
        break
      case .bottom:
        if rows > 0 {
          let indexPath = IndexPath(row: rows - 1, section: sections - 1)
          self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        break
      }
    }
    
    enum Position {
      case top
      case bottom
    }
}

extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }

            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)

            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)

                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }

            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }

            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}


extension UITableView {

    /// Check if cell at the specific section and row is visible
    /// - Parameters:
    /// - section: an Int reprenseting a UITableView section
    /// - row: and Int representing a UITableView row
    /// - Returns: True if cell at section and row is visible, False otherwise
    func isCellVisible(section:Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        
        
        return indexes.contains {
                $0.section == section && $0.row == row
        }
    }
}
