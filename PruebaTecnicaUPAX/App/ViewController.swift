//
//  ViewController.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 16/01/22.
//

import UIKit
import Photos
import FirebaseStorage

class ViewController: UIViewController {

    // MARK: - Scope
    
    let notifier = NotificationCenter.default
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.IdForCell.genericCell)
        tableView.register(UsernameCell.self, forCellReuseIdentifier: Constants.IdForCell.usernameCell)
        tableView.register(AvatarCell.self, forCellReuseIdentifier: Constants.IdForCell.avatarCell)
        tableView.register(GraphCell.self, forCellReuseIdentifier: Constants.IdForCell.graphCell)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    lazy var sendButton: UIButton = {
        let button = BaseButton.standardButton(withTitle: Constants.Strings.send)
        button.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        return button
    }()
    
    let storage = Storage.storage().reference()
    
    // MARK: - Lyfe-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mercury
        UserDefaults.standard.set(false, forKey: "was-avatar-updated")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableView()
        /**
        let tapDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        tapDismissKeyboard.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapDismissKeyboard)
        */
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = self.tableView.frame.height
        let contentHeight   = self.tableView.contentSize.height
        let centeringInset  = (tableViewHeight - contentHeight) / 2.0
        let topInset        = max(centeringInset, 0.0)
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    
    // MARK: - Custom Setup
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.heightAnchor.constraint(equalToConstant: self.view.frame.width/2).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        view.addSubview(sendButton)
        sendButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: Constants.Value.htButton).isActive = true
        sendButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }
    

    func isValidInput(with input: String) -> Bool {
        let myCharSet = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let output: String = input.trimmingCharacters(in: myCharSet.inverted)
        let isValid: Bool = (input == output)
        print("\(isValid)")
        return isValid
    }
    
    @objc private func sendRequest(){
        // Validar image selected
        var username: String = ""
        if let usernametextField = view.viewWithTag(1357911) as? UITextField {
            
            username = usernametextField.text!
            
            if username.isEmpty == true {
                let alert = UIAlertController(title: "Campo vacío",
                                              message: "El campo del nombre de usuario requiere de un valor",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: UIAlertAction.Style.default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if isValidInput(with: username) == false {
                let alert = UIAlertController(title: "Caracteres no válidos",
                                              message: "Solo se aceptan caracteres álfabeticos",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: UIAlertAction.Style.default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        }
        
        if !UserDefaults.standard.bool(forKey: "was-avatar-updated") {
            let alert = UIAlertController(title: "Seleccione una imagen diferente",
                                          message: "",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        UserDefaults.standard.set(username, forKey: "username")
        
        guard let avatarData = UserDefaults.standard.data(forKey: "avatar") else {
            return
        }
        
        // MARK: Firestore
        let path: String = "avatar-images/\(username).png"
        storage.child(path).putData(avatarData, metadata: nil) { [weak self] _, error in
            guard error == nil else {
                return
            }
            self?.storage.child(path).downloadURL { [weak self] (url, error) in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print(" url-firestore ", urlString, "\n")
                UserDefaults.standard.set(urlString, forKey: "url-firestore")
                
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Éxito!",
                                                  message: "Su imagen fue guardada.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok",
                                                  style: UIAlertAction.Style.default,
                                                  handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    
                    if let usernametextField = self?.view.viewWithTag(1357911) as? UITextField {
                        usernametextField.text = ""
                    }
                }
                
            }
        }
        
        
    }
    
    
    
}


// MARK: - Delegate & Dataspurce UITableView

enum CustomSections: CaseIterable
{
    case avatar, userName, graph
    
    static func numberOfSections() -> Int
    {
        return self.allCases.count
    }
    
    static func getSection(_ section: Int) -> CustomSections
    {
        return self.allCases[section]
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomSections.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CustomSections.getSection(indexPath.row) {
        
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.avatarCell, for: indexPath)
            if let cell = cell as? AvatarCell {
                cell.setUpView()
                return cell
            }
        case .userName:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.usernameCell, for: indexPath)
            if let cell = cell as? UsernameCell {
                cell.setUpView()
                return cell
            }
        case .graph:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.graphCell, for: indexPath)
            if let cell = cell as? GraphCell {
                cell.textLabel?.text = "Gráfica"
                cell.textLabel?.textAlignment = .center
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch CustomSections.getSection(indexPath.row) {
        case .avatar:
            self.handleEventCamera()
        case .userName: break;
        case .graph:
            let detalle: UIViewController = GraphDetailViewController()
            //self.present(detalle, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch CustomSections.getSection(indexPath.row) {
        case .avatar:
            return 90.0
        case .userName:
            return 45.0
        case .graph:
            return 45.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        let cornerRadius = Constants.Value.cornerRadius
        var corners: UIRectCorner = []

        if indexPath.row == 0
        {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
    }
    
    
}

//
// MARK: - Delegate & Dataspurce UITableView
//

enum MediaSource: String {
    case camera
    case gallery
}


extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc private func handleEventCamera() {
        selectImage()
    }
    
    func selectImage() {
        let selectPhotoAlert = UIAlertController(title: "Update Avatar",
                                                 message: "",
                                                 preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            DispatchQueue.main.async {
                self.requestPermissionsForCamera(origen: .camera)
            }
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action: UIAlertAction) in
            DispatchQueue.main.async {
                self.requestPermissionsForCamera(origen: .gallery)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        selectPhotoAlert.addAction(cameraAction)
        selectPhotoAlert.addAction(galleryAction)
        selectPhotoAlert.addAction(cancelAction)
        self.present(selectPhotoAlert, animated: true, completion: nil)
    }
    
    
    func requestPermissionsForCamera(origen: MediaSource) {
        if origen == .camera {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { status in
                if status {
                    self.openCamera()
                }
                else{
                    self.openSettings()
                }
            }
        }
        if origen == .gallery {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                        self.openGallery()
                }
                else{
                    self.openSettings()
                }
            })
        }
    }
    
    
    func openSettings() {
        let alertController = UIAlertController (title: "Requires Permission",
                                                 message: "This app requires permissions for use your Camera/Gallery.",
                                                 preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else{
                let alertVC = UIAlertController(title: "Este dispositivo no cuenta con camara",
                                                message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func openGallery() {
        DispatchQueue.main.async {
           if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
               let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = .photoLibrary
               imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
           }
        }
    }
    
    
    
    // MARK: Delegates UIPicker
    
    /**
         Swift Dictionary named “info”.
         We have to unpack it from there with a key asking for what media information we want.
         We just want the image, so that is what we ask for.
         
         For reference, the available options are:

         UIImagePickerControllerMediaType
         UIImagePickerControllerOriginalImage
         UIImagePickerControllerEditedImage
         UIImagePickerControllerCropRect
         UIImagePickerControllerMediaURL
         UIImagePickerControllerReferenceURL
         UIImagePickerControllerMediaMetadata
     
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let tempPathImagePicked = info[UIImagePickerController.InfoKey.imageURL] as? URL { // Galeria
            let imageName = tempPathImagePicked.lastPathComponent
            let nameImageFiltered = imageName.filterString(charsToRemove: ["-", " ", "_"])
            let imageExtension = nameImageFiltered.fileExtension()
            let _ = (imageName.isEmpty) ? "avatar.png" : imageName // fileName
            
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                var imageDataRepresentation: Data
                if imageExtension == "jpeg" || imageExtension == "jpg" {
                    let imageResized = pickedImage.scaled(to: CGSize(width: 1024, height: 1024),
                                                          scalingMode: UIImage.ScalingMode.aspectFill)
                    let imageCompressed = imageResized.compressImage(image: imageResized)
                    imageDataRepresentation = imageCompressed.jpegData(compressionQuality: 1.0)!
                }
                else{
                    imageDataRepresentation = pickedImage.pngData()!
                }
                
                storeImageAndReloadView(imageSelected: imageDataRepresentation)
                
            }
        }
        else{ // Desde camara.
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                let imageResized = pickedImage.scaled(to: CGSize(width: 1024, height: 1024),
                                                      scalingMode: UIImage.ScalingMode.aspectFill)
                let imageCompressed = imageResized.compressImage(image: imageResized)
                let imageDataRepresentation = imageCompressed.jpegData(compressionQuality: 1.0)!
                
                storeImageAndReloadView(imageSelected: imageDataRepresentation)
                
            }
            
        }
        
    } // imagePickerController
    
    //
    // MARK: Store in UserDefault the image selected
    //
    func storeImageAndReloadView(imageSelected: Data) {
        UserDefaults.standard.set(true, forKey: "was-avatar-updated")
        UserDefaults.standard.set("", forKey: "url-firestore")
        UserDefaults.standard.set(imageSelected, forKey: "avatar")
        let avatarCellIndexPath = IndexPath(row: 0, section: 0)
        self.tableView.reloadRows(at: [avatarCellIndexPath], with: .automatic)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
}


extension String {
    
    //
    // MARK: Filtrar Imagen en el upload de una imagen
    //
    func filterString(charsToRemove: [Character]) -> String {
        return String(self.filter { !charsToRemove.contains($0) } )
    }
    
    func fileExtension() -> String {
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        }
        else {
            return ""
        }
    }
    
    
}

extension UIImage {
    
    //
    // MARK: Upload de una imagen
    //
    func compressImage (image: UIImage) -> UIImage {
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 1024.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = img.jpegData(compressionQuality: compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
    }
    
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
}

