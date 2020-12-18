//
//  GlassSelectionCollectionViewCell.swift
//  GlassSelectionDemo
//
//  Created by Capgemini on 17/12/20.
//

import UIKit

class GlassSelectionCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
   
    @IBOutlet weak var imageView: UIImageView!
   
    override func awakeFromNib() {
           super.awakeFromNib()
           makeConer()
    }
    func makeConer() {
        self.bgView.layer.cornerRadius = 8.0
    }
    func toggleBgView() {
        if (self.isSelected){
            bgView.backgroundColor = UIColor.red
        
               }else {
                bgView.backgroundColor = UIColor.white
                self.isSelected = !isSelected
               }
        self.isSelected = !isSelected
    }

}
