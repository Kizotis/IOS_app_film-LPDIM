//
//  ViewController.swift
//  TP_IOS_v42
//
//  Created by Bouvard Antoine on 31/05/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageFilm: UIImageView!
    @IBOutlet weak var dateFilm: UILabel!
    @IBOutlet weak var dureefilm: UILabel!
    @IBOutlet weak var titreFilm: UILabel!
    @IBOutlet weak var sousTitreFilm: UILabel!
    @IBOutlet weak var categoriesFilm: UILabel!
    @IBOutlet weak var synopsisFilm: UILabel!
    @IBOutlet weak var titrecatFilm: UILabel!
    @IBOutlet weak var titresynFilm: UILabel!
    @IBOutlet weak var bandAnnonceButton: UIButton!
    @IBOutlet weak var CategFilmvIEW: UIStackView!
    
    var recupmovie: filmDetail? = nil
    var urlfilm: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titrecatFilm.backgroundColor = UIColor.systemGray2
        titrecatFilm.textColor = UIColor.white
        titresynFilm.backgroundColor = UIColor.systemGray2
        titresynFilm.textColor = UIColor.white
        bandAnnonceButton.backgroundColor = UIColor.systemGray2
        bandAnnonceButton.titleLabel?.textColor = UIColor.systemBlue
       
        if let detailfilm = recupmovie {
            titreFilm.text = detailfilm.title
            sousTitreFilm.text = detailfilm.original_title
            dateFilm.text = detailfilm.releaseDate
            dureefilm.text = "\(detailfilm.runtime ?? 0) min"
            
            categoriesFilm.text = ""
            detailfilm.genres.forEach{(genre) in
                DispatchQueue.main.async(execute: { () -> Void in
                    let textLabel = UILabel()
                    textLabel.text  = genre.name
                    textLabel.textAlignment = .center
                    self.CategFilmvIEW.addArrangedSubview(textLabel)
                    })
            }
            synopsisFilm.text = detailfilm.overview
            urlfilm = URL(string: "https://image.tmdb.org/t/p/w500/\(detailfilm.backdrop_path)")!
        }
        
    }
    
    @IBAction func clickBAFilm(_ sender: Any) {
            UIApplication.shared.openURL(urlfilm!)
    }
    
    
}

