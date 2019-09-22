//
//  MainViewController.swift
//  STUnitasImageSearcher
//
//  Created by 강진석 on 11/08/2019.
//  Copyright © 2019 jskang. All rights reserved.
//
// git test

import UIKit
import Alamofire
import Kingfisher

public class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSourcePrefetching{
    
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet var errorDescriptionLabel: UILabel!
    
    var documents = NSMutableArray()
    var pageDocuments = NSMutableArray()
    
    var timer:Timer! = nil;
    var tableViewSelectedIndex:Int = -1
    
    let maxNumOfItemsPerPage:Int = 20
    var currentPageIndex:Int = 1
    var lastPageIndex:Int = 1
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.prefetchDataSource = self;
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        searchTextField.delegate = self
        
        searchTextField.addTarget(self, action: #selector(onTextFieldDidChange), for: .editingChanged)
        
        searchTextField.placeholder = NSLocalizedString("search_text_field_place_holder", comment: "")
        
    }
    
    @objc func onTextFieldDidChange() {
        print("onTextFieldDidChange")
        let searchKeyword = searchTextField.text!
        if (timer != nil) {
            self.timer.invalidate()
            timer = nil;
        }
        
        if (searchKeyword != "") {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTableViewAfterOneSecond), userInfo: nil, repeats: false)
        }
        
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
    @objc func updateTableViewAfterOneSecond() {
        let searchKeyword = searchTextField.text!
        self.loadingIndicator.isHidden = false
        
        KakaoRestApiManager.sharedInstance.requestSearchImage(keyword: searchKeyword, onResponse:
            {(error:ImageSearchError?, documents:NSMutableArray?) in
                
                if (error == nil) {
                    self.documents = documents!
                    /*for document in documents! {
                        let imageDocument = document as! ImageDocument
                         print(imageDocument.collection!)
                         print(imageDocument.thumbnailUrl!)
                         print(imageDocument.imageUrl!)
                         print(imageDocument.width!)
                         print(imageDocument.height!)
                         print(imageDocument.siteName!)
                         print(imageDocument.documentURL!)
                         print(imageDocument.dateTime!)
                         print("\n")
                        
                        
                    }*/
                    DispatchQueue.main.async {
                        self.errorDescriptionLabel.isHidden = true
                    }
                }
                else {
                    self.documents = NSMutableArray()
                    DispatchQueue.main.async {
                        self.errorDescriptionLabel.isHidden = false
                        
                        switch(error!) {
                        case ImageSearchError.NoDocument:
                            self.errorDescriptionLabel.text = NSLocalizedString("error_description_no_search_result", comment: "")
                        case ImageSearchError.NoNetworkConnection:
                            self.errorDescriptionLabel.text = NSLocalizedString("error_description_no_network_connection", comment: "")
                        case ImageSearchError.RequestFail:
                            self.errorDescriptionLabel.text = NSLocalizedString("error_description_kakao_request_fail", comment: "")
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.initPageInformationData()
                    self.loadingIndicator.isHidden = true
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                }
        })
    }
    
    func initPageInformationData() {
        self.pageDocuments = NSMutableArray()
        self.currentPageIndex = 1
        self.lastPageIndex = (documents.count - 1) / maxNumOfItemsPerPage + 1
        
        var pagingDocumentCount:Int? = maxNumOfItemsPerPage
        if (documents.count < maxNumOfItemsPerPage) {
            pagingDocumentCount = documents.count
        }
        
        for i in 0 ..< pagingDocumentCount! {
            pageDocuments.insert(documents.object(at: i), at: i)
        }
    }
    
    // MARK: - Table view data source
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageDocuments.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        let row = indexPath.row;
        
        let currentDocument = documents.object(at: row) as! ImageDocument
        let url = URL(string:currentDocument.imageUrl)
        let processor = RoundCornerImageProcessor(cornerRadius: 40)
        cell.searchImageView.kf.setImage(with: url, options:[.processor(processor)])
        
        cell.collectionLabel.text = NSLocalizedString("image_description_collection", comment: "") + " : " + currentDocument.collection
        
        if (currentDocument.siteName == nil || currentDocument.siteName == "") {
            cell.siteLabel.text = NSLocalizedString("image_description_site", comment: "") + " : " + NSLocalizedString("image_description_unknown", comment: "")
        }
        else {
            cell.siteLabel.text = NSLocalizedString("image_description_site", comment: "") + " : " + currentDocument.siteName
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableViewSelectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetailSegue", sender: self)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == pageDocuments.count - 1 && indexPath.row != documents.count - 1) {
            self.loadMoreData()
        }
        print("row!!")
        print(indexPath.row)
        
    }
    
    func loadMoreData() {
        
        let addStartIndex:Int = calculatePageStartIndex(currentPageIndex: currentPageIndex, maxNumOfItemsPerPage: maxNumOfItemsPerPage)
        
        let addEndIndex:Int = calculatePageEndIndex(startIndex: addStartIndex, maxNumOfItemsPerPage: maxNumOfItemsPerPage, documentCount: documents.count)
        
        print(addStartIndex)
        print(addEndIndex)
        for i in addStartIndex ... addEndIndex {
            pageDocuments.insert(documents.object(at: i), at: i)
        }
        self.tableView.reloadData()
        
        
        self.currentPageIndex += 1
    }
    
    public func calculatePageStartIndex(currentPageIndex:Int, maxNumOfItemsPerPage:Int) -> Int {
        return currentPageIndex * maxNumOfItemsPerPage
    }
    
    public func calculatePageEndIndex(startIndex:Int, maxNumOfItemsPerPage:Int, documentCount:Int) -> Int {
        var endIndex:Int = startIndex + maxNumOfItemsPerPage - 1
        if (endIndex > documentCount - 1) {
            endIndex = documentCount - 1
        }
        return endIndex;
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            self.prefetchRow(ofIndex: indexPath.row)
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            self.cancelPrefetchRow(ofIndex: indexPath.row)
        }
    }
    
    func prefetchRow(ofIndex index: Int) {
        
        let indexPath = IndexPath(row: index, section: 0)
        if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
    
    func cancelPrefetchRow(ofIndex index: Int) {
        
        
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            let detailViewController = segue.destination as! DetailImageViewController
            detailViewController.imageDocument = self.documents.object(at: self.tableViewSelectedIndex) as? ImageDocument
        }
    }
}
