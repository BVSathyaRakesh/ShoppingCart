//
//  ProductListViewController.swift
//  ShoppingCartMVVM
//
//  Created by Rakesh BVS. Kumar on 2023/6/23.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productTableview : UITableView!
    
    private var viewModel = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         configuration()
        // Do any additional setup after loading the view.
    }
        
}

extension ProductListViewController {
    
    func configuration(){
        productTableview.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        initViewModel()
        observeEvents()
    }
    func initViewModel(){
        viewModel.fetchProducts()
    }
    
   //Mark: This function observes the Data Binding events in ViewModel
    func observeEvents(){
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .loading : break
            case .stopLoading : break
            case .dataLoaded:
                DispatchQueue.main.async {
                    self.productTableview.reloadData()
                }
            case .error(let error) :
                print(error)
            }
         }
    }
    
}



extension ProductListViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell else {
            return UITableViewCell()
        }
        
        let product = viewModel.products[indexPath.row]
        cell.product = product
        
        return cell
    }
}
