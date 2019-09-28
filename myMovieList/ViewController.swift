//
//  ViewController.swift
//  myMovieList
//
//  Created by Yagiz Ugur on 19.07.2019.
//  Copyright © 2019 Yagimutsu. All rights reserved.
//

// FOR IMAGES USE:  https://image.tmdb.org/t/p/w500
// Image File Path: 8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg

import UIKit
import Alamofire
import SGImageCache

//var moviePagesArr : Array<MovieDatas> = []
var movieDatas : MovieDatas = MovieDatas()
var genreDatas : GenreIDs = GenreIDs()
var moviePosters: Array<UIImage> = []
var moviePosterPages: Array<Array<UIImage>> = []
var moviePagesArr: MoviePages = MoviePages(page: [])
var collectionViewArr: Array<UICollectionView> = []
//var movieArr:Array<Movie> = []

//var isLoaded = false

class ViewController: UIViewController {
    
    //var imageCache = SGImageCache()
    
    let API_KEY = "api_key=c1ca4aec261f071871d3b86ebd36570c"
    let MOVIE_REQUEST_BY_POPULAR = "https://api.themoviedb.org/3/movie/popular?api_key=c1ca4aec261f071871d3b86ebd36570c&language=en-US&page="
    let MOVIE_REQUEST_GENRE_IDS = "https://api.themoviedb.org/3/genre/movie/list?api_key=c1ca4aec261f071871d3b86ebd36570c&language=en-US"
    let MOVIE_POSTER_BASE_URL = "https://image.tmdb.org/t/p/w500"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()

    fileprivate let topBarView: UIView = {
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/15))
        let layer = CAGradientLayer()
        layer.frame = topBar.bounds
        layer.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
        layer.shouldRasterize = true
        topBar.layer.addSublayer(layer)
        
        return topBar
    }()

    fileprivate var genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GenreCollectionViewCellModel.self, forCellWithReuseIdentifier: "genrecell")
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width/3, bottom: 0, right: UIScreen.main.bounds.width/3)
      //  cv.isPagingEnabled = true
        
        cv.tag = 1
        
        cv.allowsSelection = true
        layout.scrollDirection = .horizontal
        //cv.isScrollEnabled = false
        
        layout.minimumLineSpacing = 0
        return cv
    }()

    fileprivate var filmCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FilmCollectionViewCellModel.self, forCellWithReuseIdentifier: "filmcell")
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        layout.minimumLineSpacing = 0
        
        //cv.showsHorizontalScrollIndicator = false
        cv.tag = 2
        
        return cv
    }()
    
    func showActivityIndicator(){
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(){
        activityIndicator.stopAnimating()
    }
    
    func requestFilteredFilmData(pageNum:Int, genreID: Int, indexRow: Int) {
       
        let DISCOVER_MOVIE_URL = "https://api.themoviedb.org/3/discover/movie?\(API_KEY)&sort_by=popularity.desc&page=\(String(pageNum))&with_genres=\(genreID)"
        
        Alamofire.request(DISCOVER_MOVIE_URL, method: .get).responseData {
            response in
            if response.result.isSuccess {
                
                movieDatas = MovieDatas()
                
                movieDatas = try! JSONDecoder().decode(MovieDatas.self, from: response.data!)
                
                print(movieDatas)
                
                moviePagesArr.page.append(movieDatas)
                
                //print(movieDatas)
                //moviePagesArr.append(movieDatas)
                var moviePostersTemp: Array<UIImage> = []
                
                for i in 0...movieDatas.results!.count - 1 {
                    let url = URL(string: (self.MOVIE_POSTER_BASE_URL + (movieDatas.results![i].poster_path ?? "")))
                    let data = try? Data(contentsOf: url!)
                
                    let img = UIImage(data: data ?? Data()) ?? UIImage()
                    
                    let sgImgCache = SGImageCache.getImageForURL(url!.absoluteString)
                    
                    
                
                    
                    
                    moviePostersTemp.append(img)
                    
                }
                
                if !moviePosterPages[indexRow].isEmpty {
                    
                    moviePosters = []
                    moviePosters = moviePostersTemp
                    moviePosterPages[indexRow] = moviePosters
                    //moviePages.append(moviePosters)
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        collectionViewArr[1 + indexRow].reloadData()
                        //self.filmCollectionView.reloadData()
                        
                        
                        let visItems = collectionViewArr[1 + indexRow].indexPathsForVisibleItems
                        collectionViewArr[1 + indexRow].reloadItems(at: visItems)
                        self.hideActivityIndicator()
                        collectionViewArr[1 + indexRow].isHidden = false
                    }
                    
                } else {
                    
                    moviePosters = moviePostersTemp
                    moviePosterPages[indexRow] = moviePosters
                    //moviePages.append(moviePosters)
                    
                    DispatchQueue.main.async {
                        
                        collectionViewArr[1 + indexRow].reloadData()
                        //self.scrollToItem(indexPath: [0,indexRow])
                        let visItems = collectionViewArr[1 + indexRow].indexPathsForVisibleItems
                        collectionViewArr[1 + indexRow].reloadItems(at: visItems)
                        self.hideActivityIndicator()
                        collectionViewArr[1 + indexRow].isHidden = false
                        
                    }
                    
                }
                
            } else {
                print("ERROR OCCURED! \(response.result.error ?? "THERE IS SOMETHING WRONG" as! Error)")
                
            }
            
        }
    
    }
    
    func requestGenreData() {
        
        Alamofire.request(self.MOVIE_REQUEST_GENRE_IDS, method: .get).responseData {
            response in
            if response.result.isSuccess {
                print("GENRE SUCCESS!")
                
                genreDatas = try! JSONDecoder().decode(GenreIDs.self, from: response.data!)
                //print(genreDatas)
        
                self.genreCollectionView.reloadData()
                collectionViewArr.append(self.genreCollectionView)
                
                for i in 0...genreDatas.genres!.count - 1 {
                    var filmCV = self.filmCollectionView
                    filmCV.tag = i + self.filmCollectionView.tag
                    collectionViewArr.append(filmCV)
                    moviePagesArr.page.append(MovieDatas())
                    moviePosterPages.append([])
                    
                }
                
                self.showActivityIndicator()
                self.getDataForThreePages(pageNum: 0)
                
                print("Genre request is finished")
            
            } else {
                print("ERROR OCCURED! (GENRE) \(response.result.error ?? "THERE IS SOMETHING WRONG (GENRE)" as! Error)")
            }
        }
        
    }
    
    func getIndexOfFilmPage(index: IndexPath) -> IndexPath {
        
        return index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showActivityIndicatory()
    
        view.addSubview(topBarView)
        view.addSubview(activityIndicator)
        view.addSubview(genreCollectionView)
        view.addSubview(filmCollectionView)
        //filmCollectionView.addSubview(activityIndicator)
        DispatchQueue.main.async {
            self.showActivityIndicator()
            self.requestGenreData()
        }
        
        //activityIndicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 + (topBarView.bounds.height + genreCollectionView.bounds.height + ((UIScreen.main.bounds.width-posterWidth*2)))/2)
        
        topBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBarView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topBarView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (topBarView.bounds.height - UIScreen.main.bounds.height)).isActive = true
        
        genreCollectionView.topAnchor.constraint(equalTo: topBarView.bottomAnchor).isActive = true
        genreCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        genreCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        genreCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:(topBarView.bounds.height*2.5 - UIScreen.main.bounds.height)).isActive = true
 
        filmCollectionView.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor).isActive = true
        filmCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        filmCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        filmCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        genreCollectionView.backgroundColor = .black
        filmCollectionView.backgroundColor = .black
       
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        filmCollectionView.delegate = self
        filmCollectionView.dataSource = self
        
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 + topBarView.bounds.height)
        //activityIndicator.center = CGPoint(x: filmCollectionView.bounds.width/2, y: filmCollectionView.bounds.height/2)
        showActivityIndicator()
        
        for i in 0...genreDatas.genres!.count - 1 {
            var filmCV = self.filmCollectionView
            filmCV.tag = i + self.filmCollectionView.tag
            collectionViewArr.append(filmCV)
        }
        
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    //MARK: Size of Elements
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height/1.5)
        } else if collectionView.tag == 2 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: CGFloat(250*1.375).pixelsToPoints(), height: CGFloat(375*1.375).pixelsToPoints())
        }
        
    }
    
    //MARK: Number of Items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            return genreDatas.genres?.count ?? 0
        } else if collectionView.tag == 2 {
            return genreDatas.genres?.count ?? 0
        } else {
            return moviePagesArr.page[collectionView.tag].results?.count ?? 0
        }
        
    }
    
    //MARK: Item at Index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genrecell", for: indexPath) as! GenreCollectionViewCellModel
            cell.genreLabel.text = genreDatas.genres?[indexPath.row].name
            //cell.genreID = genreDatas.genres![indexPath.row].id
            
            //filterFilmsByGenre(genreID: cell.genreID, pageNum: indexPath.row)
            collectionViewArr.append(collectionView)
            return cell
            
        } /*else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmcell", for: indexPath) as! FilmCollectionViewCellModel
            cell.filmPosterCollectionView = collectionViewArr[indexPath.row + 1]
            cell.filmPosterCollectionView.reloadData()
            let path = cell.filmPosterCollectionView.indexPathsForVisibleItems
            cell.filmPosterCollectionView.reloadItems(at: path)
            //cell.backgroundColor = .purple
            //cell.filmPosterCollectionView = collectionViewArr[indexPath.row + 2]
            //cell.filmPosterCollectionView.tag = indexPath.row + 3 // Add 3 because we already have 2 collectionViews with tag 1 and 2
            //print(cell.filmPosterCollectionView.tag)
            //collectionViewArr.append(cell.filmPosterCollectionView)
            return cell
        } */else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postercell", for: indexPath) as! FilmPosterCollectionViewCellModel
            //cell.filmPosterCollectionView.
            cell.backgroundColor = .red
            //print(moviePagesArr[collectionView.tag - 3].results![indexPath.row].title)
            cell.poster.image = UIImage()
            cell.title.text = "???"
            collectionViewArr.append(collectionView)
            //cell.poster.image = moviePagesArr[]
            //cell.title.text = moviePagesArr[indexPath.row].results![indexPath.row].title
            return cell
        }
        
    }
    
    //MARK: Spacing for elements
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView.tag == 0 {
            return (UIScreen.main.bounds.width-posterWidth*2)/3
        } else {
            return 0
        }
        
    }
    
    func scrollToItem(indexPath: IndexPath) {
        
        collectionViewArr[0].scrollToItem(at: indexPath, at: [.centeredHorizontally,.centeredVertically], animated: true)
        collectionViewArr[1].selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally,.centeredVertically])
        
    }
    
    // This func is checks the index and request data accordingly.
    func getDataForThreePages(pageNum: Int) {
        
        DispatchQueue.main.async {
            if pageNum == 0 {
                self.requestFilteredFilmData(pageNum: 1, genreID: genreDatas.genres![pageNum].id, indexRow: pageNum)
            }
            
            
        }
        
    }
    
    //MARK: Case of a selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            
            //let cell = collectionViewArr[1].dequeueReusableCell(withReuseIdentifier: "filmcell", for: indexPath) as! FilmCollectionViewCellModel
            
            //cell.filmPosterCollectionView.setContentOffset(CGPoint(x: 0, y: -cell.filmPosterCollectionView.contentInset.top), animated: false)
            //hideActivityIndicator()
            
            scrollToItem(indexPath: indexPath)
            
            collectionViewArr[1 + indexPath.row].isHidden = true
            
            showActivityIndicator()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                
                self.getDataForThreePages(pageNum: indexPath.row)
            }
          
            print("Selected Genre is: \(genreDatas.genres![indexPath.row].name), IndexPath is: \(indexPath)")
            
        }
        else if collectionView.tag == 2 {
            print("Films cell at \(indexPath) is selected.")
            
        } else {
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postercell", for: indexPath) as! FilmPosterCollectionViewCellModel
            print("The film '\(movieDatas.results![indexPath.row].title)' at \(indexPath) is selected.")
            print("CollectionView Tag: \(collectionView.tag)")
        }
    }
    
    func hidePages(pageNum: Int) {
        if !collectionViewArr.isEmpty {
            if pageNum == 0 {
                
                collectionViewArr[pageNum].isHidden = true
                collectionViewArr[pageNum + 1].isHidden = true
                
            } else if pageNum == genreDatas.genres!.count - 1 {
                
                collectionViewArr[pageNum - 1].isHidden = true
                collectionViewArr[pageNum].isHidden = true
                
            } else {
                
                collectionViewArr[pageNum - 1].isHidden = true
                collectionViewArr[pageNum].isHidden = true
                collectionViewArr[pageNum + 1].isHidden = true
                
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 2 {
            let x = scrollView.contentOffset.x
            let w = scrollView.bounds.size.width
            let currentPage = Int((x/w))
            print(currentPage)
            
            hidePages(pageNum: currentPage)
            
            collectionViewArr[0].selectItem(at: [0,currentPage], animated: true, scrollPosition: .centeredHorizontally)
            
            showActivityIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(500)) {
                
                self.getDataForThreePages(pageNum: currentPage)
            }
            
        }
        
    }

}

public extension CGFloat {
    /**
     Converts pixels to points based on the screen scale. For example, if you
     call CGFloat(1).pixelsToPoints() on an @2x device, this method will return
     0.5.
     
     - parameter pixels: to be converted into points
     
     - returns: a points representation of the pixels
     */
    func pixelsToPoints() -> CGFloat {
        return self / UIScreen.main.scale
    }
    
    /**
     Returns the number of points needed to make a 1 pixel line, based on the
     scale of the device's screen.
     
     - returns: the number of points needed to make a 1 pixel line
     */
    static func onePixelInPoints() -> CGFloat {
        return CGFloat(1).pixelsToPoints()
    }
}
