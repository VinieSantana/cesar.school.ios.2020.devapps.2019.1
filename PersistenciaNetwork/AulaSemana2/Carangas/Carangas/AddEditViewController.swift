//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    
    var car: Car!
    
    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var brands: [Brand] = []
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    } ()
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBrands()
        if car != nil {
            // modo edicao
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Alterar carro", for: .normal)
        }
        
        // 1 criamos uma toolbar e adicionamos como input do textview
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancel, btSpace, btDone]
        
        tfBrand.inputAccessoryView = toolbar
        tfBrand.inputView = pickerView
        
    }
    
    func loadBrands() {
        startLoadingAnimation()
        REST.loadBrands(onComplete: { (brands) in
            if let brands = brands{
                
                self.brands = brands.sorted(by: {$0.fipe_name < $1.fipe_name})
                
                DispatchQueue.main.async {
                    self.stopLoadingAnimation()
                    self.pickerView.reloadAllComponents()
                }
            }
        }) { (err) in
            self.showAlertError(withTitle: "Carregar marcas", withMessage: "Problema ao carregar marcas" + REST.friendfyError(carError: err), isTryAgain: true, operation: .get_brands)
        }
    }
    
    // MARK: - IBActions
    fileprivate func saveCar() {
        startLoadingAnimation()
        REST.save(car: car, onComplete: { (success) in
            
            self.goBack()
            
        }) { (err) in
            self.showAlertError(withTitle: "Salvar", withMessage: "Problema ao tentar SALVAR" + REST.friendfyError(carError: err), isTryAgain: true, operation: .add_car)
        }
    }
    
    fileprivate func updateCar() {
        startLoadingAnimation()
        REST.update(car: car, onComplete: { (success) in
            
            self.goBack()
            
        }) { (err) in
            self.showAlertError(withTitle: "Editar", withMessage: "Problema ao tentar EDITAR" + REST.friendfyError(carError: err), isTryAgain: true, operation: .edit_car)
        }
    }
    
    @IBAction func addEdit(_ sender: UIButton) {
        
        if car == nil {
            // adicionar carro novo
            car = Car()
        }
        
        car.name = (tfName?.text)!
        car.brand = (tfBrand?.text)!
        if tfPrice.text!.isEmpty {
            tfPrice.text = "0"
        }
        car.price = Double(tfPrice.text!)!
        car.gasType = scGasType.selectedSegmentIndex
        
        // 1
        if car._id == nil {
            
            saveCar()
            
        } else {
            updateCar()
        }
        
    }
    
    func goBack() {
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func cancel() {
        tfBrand.resignFirstResponder()
    }
    
    @objc func done() {
        tfBrand.text = brands[pickerView.selectedRow(inComponent: 0)].fipe_name
        cancel()
    }
    
    func startLoadingAnimation() {
        self.btAddEdit.isEnabled = false
        self.btAddEdit.backgroundColor = .gray
        self.btAddEdit.alpha = 0.5
        self.loading.startAnimating()
    }
    
    func stopLoadingAnimation() {     
        self.btAddEdit.isEnabled = true
        self.btAddEdit.backgroundColor = UIColor(named: "main")
        self.btAddEdit.alpha = 1
        self.loading.stopAnimating()
    }
    
    enum CarOperationAction {
        case add_car
        case edit_car
        case get_brands
    }
} // fim da classe

extension AddEditViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let brand = brands[row]
        return brand.fipe_name
    }
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func showAlertError(withTitle titleMessage: String, withMessage message: String, isTryAgain hasRetry: Bool, operation oper: CarOperationAction) {
        self.stopLoadingAnimation()
        if oper != .get_brands {
            DispatchQueue.main.async {
                // ?
            }
            
        }
        
        let alert = UIAlertController(title: titleMessage, message: message, preferredStyle: .actionSheet)
        
        if hasRetry {
            let tryAgainAction = UIAlertAction(title: "Tentar novamente", style: .default, handler: {(action: UIAlertAction) in
                
                switch oper {
                case .add_car:
                    self.saveCar()
                case .edit_car:
                    self.updateCar()
                case .get_brands:
                    self.loadBrands()
                }
                
            })
            alert.addAction(tryAgainAction)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(action: UIAlertAction) in
                self.goBack()
            })
            alert.addAction(cancelAction)
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

