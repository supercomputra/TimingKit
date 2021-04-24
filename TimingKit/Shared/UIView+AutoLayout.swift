//
//  UIView+AutoLayout.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import UIKit


public enum AutoLayoutAlignment {
    case fill(insets: UIEdgeInsets = .zero)
    case center(maxSize: CGSize? = nil)
}

extension UIView {
    func addSubview(_ subview: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    
    func addSubview(_ subview: UIView, alignment: AutoLayoutAlignment) {
        switch alignment {
        case .fill(let insets):
            addSubview(subview, constraints: [
                subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
                subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
            ])
        case .center(let maxSize):
            var constraints: [NSLayoutConstraint] = [
                subview.centerXAnchor.constraint(equalTo: centerXAnchor),
                subview.centerYAnchor.constraint(equalTo: centerYAnchor),
                subview.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
                subview.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            ]
            
            if let `maxSize`: CGSize = maxSize {
                constraints.append(subview.heightAnchor.constraint(equalToConstant: maxSize.height).withPriority(.defaultLow))
                constraints.append(subview.widthAnchor.constraint(equalToConstant: maxSize.width).withPriority(.defaultLow))
                constraints.append(subview.widthAnchor.constraint(equalTo: heightAnchor, multiplier: maxSize.width/maxSize.height))
            }
            
            addSubview(subview, constraints: constraints)
        }
    }
}

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

public protocol ReuseIdentifiable {}

extension UITableViewCell: ReuseIdentifiable {}

extension UICollectionViewCell: ReuseIdentifiable {}

extension ReuseIdentifiable {
    /**
     Auto generated unique reuseIdentifier based on the class name
     */
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    /**
     Convenience register reusable cell.
     - Parameter cellClass: The rusable cell's class.
     - Returns: The casted dequeueing cell's instance.
     */
    public func register<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    /**
     Convenience dequeue registered reusable cell with indexPath.
     - Parameter indexPath: The dequeueing cell's indexPath.
     - Returns: The casted dequeueing cell's instance.
     - Requires: This method requires cell class to be registered using: registerReusableCell(_:)
     */
    public func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        let cell: Cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        return cell
    }
}

final class GenericTableViewCell<T: UIView>: UITableViewCell {
    
    var view: T = T()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.view)
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
