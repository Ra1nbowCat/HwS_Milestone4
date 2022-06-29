//
//  PictureViewController.swift
//  Milestone4
//
//  Created by Илья Лехов on 29.06.2022.
//

import UIKit

class PictureViewController: UIViewController {
    
    var pictureName: String?
    @IBOutlet var pictureImageView: UIImageView!    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = pictureName {
            pictureImageView.image = UIImage(contentsOfFile: imageToLoad)
        }
    }

}
