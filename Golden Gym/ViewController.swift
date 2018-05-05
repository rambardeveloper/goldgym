//
//  ViewController.swift
//  Golden Gym
//
//  Created by Andres Rambar on 5/3/18.
//  Copyright © 2018 Rambar. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //arrays de datos para los pickers
    var agesList = [String]()
    var weigthList = [String]()
    var heightListM = [String]()
    var heightListCm = [String]()

    
    //Outlets
    @IBOutlet weak var edadTextField: UITextField!
    @IBOutlet weak var pesoTextField: UITextField!
    @IBOutlet weak var alturaTextField: UITextField!
    @IBOutlet weak var sexoSegmentedControl: UISegmentedControl!
    
    
    //pickers
    var edadPicker = UIPickerView()
    var pesoPicker = UIPickerView()
    var alturaPicker = UIPickerView()

    //auxs
    var auxHeigthM = ""
    var auxHeigthCm = ""
    
    //vars
    var sexoSelected="Hombre"
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == alturaPicker{
            return 2
        }else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == edadPicker{
            return agesList.count
        }else if pickerView == pesoPicker{
            return weigthList.count
        }else{
            if component == 0{
                return heightListM.count
            }else{
                return heightListCm.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == edadPicker{
            return agesList[row]
        }else if pickerView == pesoPicker{
            return weigthList[row]
        }else{
            if component == 0{
                return heightListM[row]
            }else{
                return heightListCm[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == edadPicker{
            edadTextField.text = agesList[row]
        }else if pickerView == pesoPicker{
            pesoTextField.text = weigthList[row]
        }else{
            if component == 0{
                auxHeigthM=heightListM[row]
            }else{
                auxHeigthCm=heightListCm[row]
            }
            alturaTextField.text = auxHeigthM + "." + auxHeigthCm
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
        //list of ages
        var i = 0
        while i<70 {
            agesList.append(String(i+12))
            i+=1
        }
        print("Las edades son:  \(agesList)")
        
        //list of weights
        i=0
        while i<150{
            weigthList.append(String(i+10))
            i+=1
        }
        print("Los pesos son:  \(weigthList)")
        
        //list of heigths
        heightListM.append(contentsOf: ["0","1","2"])
        i=0
        while i<100{
            heightListCm.append(String(i))
            i+=1
        }
        
        //picker for age selection
        pickUp(edadTextField, &edadPicker)
//        edadTextField.inputView = edadPicker
//        edadPicker.delegate = self
        
        //picker for weight selection
        pickUp(pesoTextField, &pesoPicker)
//        pesoTextField.inputView = pesoPicker
//        pesoPicker.delegate = self
        
        //picker for heigth selection
        pickUp(alturaTextField, &alturaPicker)
//        alturaTextField.inputView = alturaPicker
//        alturaPicker.delegate = self
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sexoSegmentedControlSwitch(_ sender: UISegmentedControl) {
        switch sexoSegmentedControl.selectedSegmentIndex{
            case 0:
                self.sexoSelected="Hombre";
            case 1:
                self.sexoSelected="Mujer";
            default:
                break
        }
        print("Sexo \(self.sexoSelected)")
    }
    
    @IBAction func CalcularIMC(_ sender: UIButton) {
        let edad =  Int(edadTextField.text!)
        let peso = Int(pesoTextField.text!)
        let altura = Float(alturaTextField.text!)
        let sexo = self.sexoSelected
        let alturaAlCuadrado = powf(altura!, 2)
        let imc = Float(peso!)/alturaAlCuadrado
        var title:String=""
        var message:String=""
        let imcText = "Su indice de masa corporal es \(imc). "
        print("Edad \(edad!), peso \(peso!), altura \(altura!), sexo \(sexo), imc \(imc)")
        switch imc{
            case ..<18:
                title="Peso bajo"
                message=imcText+"Esto se considera peso bajo y es necesario valorar signos de desnutrición"
            case 18..<25:
                title="Normal"
                message=imcText+"Usted tiene niveles normales de indice de masa corporal"
            case 25..<27:
                title="Sobrepeso"
                message=imcText+"Esto significa niveles altos de grasa en el cuerpo"
            case 27..<30:
                title="Obesidad grado 1"
                message=imcText+"Corre un riesgo relativo ​alto ​ para desarrollar enfermedades cardiovasculares"
            case 30..<40:
                title="Obesidad grado 2"
                message=imcText+"Corre un riesgo ​muy alto ​ para el desarrollo de enfermedades cardiovasculares"
            case 40...:
                title="Obesidad grado 3"
                message=imcText+"Corre un riesgo extremadamente alto ​ para el desarrollo de enfermedades cardiovasculares"
            default:
                break
        }
        //coredata
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Records", in: context)
        let newRecord = NSManagedObject(entity: entity!, insertInto: context)
        newRecord.setValue(peso!, forKey: "peso")
        newRecord.setValue(edad!, forKey: "edad")
        newRecord.setValue(altura!, forKey: "altura")
        newRecord.setValue(sexo, forKey: "sexo")
        newRecord.setValue(imc, forKey: "imc")
        
        let date = Date()
//        let calendar = Calendar.current
        newRecord.setValue(date, forKey: "fecha")
        //end coredata
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        //try
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Records")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "sexo") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
        //
    }
    
    func pickUp(_ textField : UITextField, _ picker : inout UIPickerView){
        
        // UIPickerView
        picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        textField.inputView = picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    //MARK:- Button
    @objc func doneClick() {
        pesoTextField.resignFirstResponder()
        edadTextField.resignFirstResponder()
        alturaTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        pesoTextField.resignFirstResponder()
        edadTextField.resignFirstResponder()
        alturaTextField.resignFirstResponder()
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.pickUp(txt_pickUpData)
//    }
}

