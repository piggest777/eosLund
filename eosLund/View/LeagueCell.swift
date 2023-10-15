//
//  LeagueCell.swift
//  eosLund
//
//  Created by Denis Rakitin on 2023-10-15.
//  Copyright © 2023 Denis Rakitin. All rights reserved.
//

import Foundation
import UIKit

class LeagueCell: UICollectionViewCell {
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private var underlineView: UIView?
    
    func setHighlighted(_ highlighted: Bool) {
            if highlighted {
                addUnderline()
            } else {
                removeUnderline()
            }
        }
        
        private func addUnderline() {
            underlineView = UIView()
            underlineView?.translatesAutoresizingMaskIntoConstraints = false
            underlineView?.backgroundColor = .white
            
            guard let underlineView = underlineView else { return }
            addSubview(underlineView)
            
            NSLayoutConstraint.activate([
                underlineView.heightAnchor.constraint(equalToConstant: 2),
                underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
                underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
                underlineView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        private func removeUnderline() {
            underlineView?.removeFromSuperview()
            underlineView = nil
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        removeUnderline()
        label.textColor = UIColor(named: "backgroundText")
    }
    
    func setupViews() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
