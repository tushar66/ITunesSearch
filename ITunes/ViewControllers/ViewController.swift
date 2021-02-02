//
//  ViewController.swift
//  ITunes
//
//  Created by Tushar Mendiratta on 31/01/21.
//  Copyright © 2021 None. All rights reserved.
//

import UIKit

import UIKit
import Kingfisher

class ViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var search: UISearchBar!
  @IBOutlet weak var commentLabel: UILabel!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  let model = ViewModel()
  var dataToUI = [Track]()
  var searchData = [String]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Artist Search"
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    startSettings()
    setupViewModel()
  }

  
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
  
  
  func startSettings (){
    collectionView.dataSource = self
    collectionView.delegate = self
    tableView.dataSource = self
    tableView.delegate = self
    search.delegate = self
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
    
    commentLabel.text = ""
  }
  
  
  private func setupViewModel() {
    model.didUpdateDataToUI = { [weak self] data in
      guard let self = self else { return }
      self.dataToUI = data
      
      DispatchQueue.main.async {
        self.spinner.stopAnimating()
        self.collectionView.reloadData()
      }
      self.checkComment()
    }
    
    model.didUpdateSearchArrayToUI = { [weak self] data in
      guard let self = self else { return }
      self.searchData = data
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  
  private func checkComment() {
    if self.model.comment != nil {
      self.commentLabel.isHidden = false
      self.commentLabel.text = self.model.comment
      self.spinner.stopAnimating()
    } else {
      self.commentLabel.isHidden = true
    }
  }
  
}


//MARK: - UICollectionViewDataSource Method
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataToUI.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SongsCollectionViewCell
    
    
    cell.artistLbl.text = dataToUI[indexPath.row].artistName
    cell.trackNameLbl.text = dataToUI[indexPath.row].trackName
    cell.albumLbl.text = dataToUI[indexPath.row].collectionName
    cell.genreLbl.text = dataToUI[indexPath.row].primaryGenreName
    
    if let trackTimeMillis = dataToUI[indexPath.row].trackTimeMillis {
        let duration = trackTimeMillis.msToSeconds.minuteSecond
        
        cell.priceLbl.text = "\(duration) - \( dataToUI[indexPath.row].trackPrice ?? 0.00) \( dataToUI[indexPath.row].currency ?? "")"
    } else{
        cell.priceLbl.text = "\( dataToUI[indexPath.row].trackPrice ?? 0.00) \( dataToUI[indexPath.row].currency ?? "")"
    }
    
    
    let fileUrl = URL(string: dataToUI[indexPath.row].artworkUrl100 ?? "")
    cell.artWorkImg.kf.setImage(with: fileUrl)
    
    
    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        vc.data = dataToUI[indexPath.row]
        self.navigationController!.pushViewController( vc, animated: true)
    }
  
}


//MARK: - CollectionViewDelegateFlowLayout Methods
extension ViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = (collectionView.frame.width / 2 - 12) + 120
    let width  = collectionView.frame.width / 2 - 12
    
    return CGSize(width: width, height: height)
    
  }
  
}


//MARK: - UISearchBarDelegate Methods
extension ViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    if let text = searchBar.text {
      model.request(with: text)
      spinner.startAnimating()
    }
    checkComment()
    tableView.isHidden = true
    searchBar.resignFirstResponder()
  }
  
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    tableView.isHidden = false
    
    if searchBar.text?.count == 0 {
      dataToUI = []
      self.searchData = []
      
      
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
        self.tableView.isHidden = true
        self.spinner.stopAnimating()
        self.tableView.reloadData()
        self.collectionView.reloadData()
      }
    } else if searchBar.text!.count >= 2 {
      model.search(searchBar.text!)
    }
  }
  
}


//MARK: - TableView Methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchData.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
    cell.label.text = searchData[indexPath.row]
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let text = searchData[indexPath.row]
    tableView.isHidden = true
    checkComment()
    model.request(with: text)
  }
  
}



