//
//  ViewController.swift
//  CryptoApp
//
//  Created by C on 21.10.2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let aiv = UIActivityIndicatorView()
    
    var cryptoList = [Crypto]()
    let cryptoVM = CryptoViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableView()
        setupIndicator()
        setupBindings()
        
        cryptoVM.requestData()
    }
    
    private func setupIndicator(){
        
        aiv.hidesWhenStopped = true
        aiv.center = view.center
        aiv.style = .medium
        
        view.addSubview(aiv)
        aiv.startAnimating()
    }

    private func setupTableView() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        
        view.addSubview(tableView)
    }
    
    private func setupBindings() {
            
            cryptoVM
                .cryptos
                .observe(on: MainScheduler.asyncInstance)
                .subscribe { cryptos in
                    self.cryptoList = cryptos
                    self.tableView.reloadData()
                }.disposed(by: disposeBag)
            
            
            cryptoVM
                .error
                .observe(on: MainScheduler.asyncInstance)
                .subscribe { error in
                    print(error)
                }.disposed(by: disposeBag)
            
       
            cryptoVM
                .loading
                .bind(to: self.aiv.rx.isAnimating)
                .disposed(by: disposeBag)
            
            
            cryptoVM
                .loading
                .observe(on: MainScheduler.asyncInstance)
                .subscribe { bool in
                    print(bool)
                }.disposed(by: disposeBag)
            
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content

        return cell
    }

}
