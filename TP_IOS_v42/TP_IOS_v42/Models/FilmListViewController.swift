//
//  FilmListViewController.swift
//  TP_IOS_v42
//
//  Created by Bouvard Antoine on 02/06/2021.
//

import UIKit

struct Movie {
    let title: String
    let subTitle: String
}

struct ReturnFilm: Decodable {
    let results: [filmDetail]
    let page: Int
    let total_pages: Int
    let total_results: Int
}

struct MovieGenres : Decodable{
    var id : Int
    var name : String
    
    init(id : Int,name : String) {
        self.id = id
        self.name = name
        
       }
}


struct filmDetail: Decodable {
    let adult: Bool
    let backdrop_path: String
    let genre_ids: [Int]
    let genres: Array<MovieGenres>
    let id: Int
    let original_language: String
    let original_title: String
    let popularity: Float
    let title: String
    let overview: String
    let releaseDate: String
    let poster_path: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
    let runtime: Int
}

class FilmListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableviewListFilm: UITableView!
    var movies: [filmDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        resolveURL {
            DispatchQueue.main.async {
                self.setupViews()
            }
        }
    }
    
    func resolveURL(completion: @escaping () -> Void )  {
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=56e27ac0065ffe89afc74212f903065c")!
        let task: URLSessionDataTask = session.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                let filmsResults = try? JSONDecoder().decode(ReturnFilm.self, from: data)
                
                for film in filmsResults!.results {
                    //self.movies.append(film)
                    let urlDetail = URL(string:"https://api.themoviedb.org/3/movie/\(film.id)api_key=56e27ac0065ffe89afc74212f903065c")!
                    let taskDetail: URLSessionDataTask = session.dataTask(with: urlDetail) { (data,response,error) in
                        if let data = data {
                            let filmDetail = try? JSONDecoder().decode(filmDetail.self,from: data)
                            self.movies.append(filmDetail!)
                            
                            completion()
                        }
                    }
                    taskDetail.resume()
                }
            }
        }
        task.resume()
    }
    
    func setupViews() {
        title = "Liste des films"
        tableviewListFilm.delegate = self
        tableviewListFilm.dataSource = self
        tableviewListFilm.rowHeight = UITableView.automaticDimension
        tableviewListFilm.estimatedRowHeight = UITableView.automaticDimension
        tableviewListFilm.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    
    func numberOfSections(in tableviewListFilm: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableviewListFilm: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableviewListFilm: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableviewListFilm: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviewListFilm.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let movie = movies[indexPath.row]
        let dbCover = "https://image.tmdb.org/t/p/w500"
        
        cell.titreFilmlist.text = movie.title
        cell.synopsisFilmlist.text = movie.overview
        cell.dateFilmlist.text = movie.releaseDate
        let url = URL(string: dbCover + movie.poster_path)
        let data = try? Data(contentsOf: url!)
        cell.imgFilmlist.image = UIImage(data: data!)

        return cell
    }
    
    func tableviewListFilm(_ tableviewListFilm: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableviewListFilm.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        
        //let storyboard = UIStoryboard(name: "FilmListViewController", bundle: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customViewController = storyboard.instantiateViewController(withIdentifier: "Mainview") as! ViewController
        customViewController.recupmovie = movie
        navigationController?.pushViewController(customViewController, animated: true)
    }
    
    
}
