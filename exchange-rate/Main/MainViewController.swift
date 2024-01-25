import UIKit

class MainViewController: UIViewController {
    private var recipientCountry = ["한국(KRW)","일본(JPY)","필리핀(PHP)"]
    private var exchangeRate: [String:Double] = [:]
    private var currentCountry = "USDKRW"
    private let mainViewModel = MainViewModel()
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 계산"
        label.font = .systemFont(ofSize: 45)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remittanceCountryLabel: UILabel = {
        let label = UILabel()
        label.text = "송금국가 : 미국(USD)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var recipientCountryLabel: UITextView = {
        let textView = UITextView()
        textView.text = "수취국가 : 한국(KRW)"
        textView.font = .systemFont(ofSize: 17)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var requestTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "조회시간 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var remittanceLabel: UILabel = {
        let label = UILabel()
        label.text = "송금액 : "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var remittanceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = String(calculate())
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(remittanceCountryLabel)
        view.addSubview(recipientCountryLabel)
        view.addSubview(exchangeRateLabel)
        view.addSubview(requestTimeLabel)
        view.addSubview(remittanceLabel)
        view.addSubview(remittanceTextField)
        view.addSubview(unitLabel)
        view.addSubview(resultLabel)
        
        recipientCountryLabel.inputView = countryPickerView
        
        fetchExchangeRates()
        setLayout()
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        remittanceTextField.delegate = self
    }
    
    private func fetchExchangeRates() {
        mainViewModel.fetchExchangeRates { result in
            switch result {
            case .success(let currentRate):
                self.exchangeRate = currentRate.quotes
                
                DispatchQueue.main.async {
                    self.changeUI()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //UI 변경
    private func changeUI() {
        let formattedNumber = numberFormatter.string(from: NSNumber(value: exchangeRate[currentCountry]!))
        self.exchangeRateLabel.text = "환율 : " + formattedNumber!
    }
    
    //환율 계산
    private func calculate() -> String {
        var result: Double = 0
        guard let remittanceAmount = Double(remittanceTextField.text ?? "") else { return "" }
        
        result = exchangeRate[currentCountry]! * remittanceAmount
        
        let formattedResult = numberFormatter.string(from: NSNumber(value: result))!
        
        return formattedResult
    }
    
    //레이아웃 설정
    private func setLayout() {
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        remittanceCountryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        remittanceCountryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        recipientCountryLabel.topAnchor.constraint(equalTo: remittanceCountryLabel.bottomAnchor, constant: 15).isActive = true
        recipientCountryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        recipientCountryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        recipientCountryLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        exchangeRateLabel.topAnchor.constraint(equalTo: recipientCountryLabel.bottomAnchor, constant: 20).isActive = true
        exchangeRateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 59).isActive = true
        
        requestTimeLabel.topAnchor.constraint(equalTo: exchangeRateLabel.bottomAnchor, constant: 20).isActive = true
        requestTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        remittanceLabel.topAnchor.constraint(equalTo: requestTimeLabel.bottomAnchor, constant: 20).isActive = true
        remittanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45).isActive = true
        remittanceLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        remittanceTextField.topAnchor.constraint(equalTo: requestTimeLabel.bottomAnchor, constant: 20).isActive = true
        remittanceTextField.leadingAnchor.constraint(equalTo: remittanceLabel.trailingAnchor, constant: 0).isActive = true
        remittanceTextField.centerYAnchor.constraint(equalTo: remittanceLabel.centerYAnchor).isActive = true
        
        unitLabel.topAnchor.constraint(equalTo: requestTimeLabel.bottomAnchor, constant: 20).isActive = true
        unitLabel.leadingAnchor.constraint(equalTo: remittanceTextField.trailingAnchor, constant: 5).isActive = true
        unitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        unitLabel.centerYAnchor.constraint(equalTo: remittanceLabel.centerYAnchor).isActive = true
        
        resultLabel.topAnchor.constraint(equalTo: remittanceLabel.bottomAnchor, constant: 50).isActive = true
        resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        resultLabel.text = String(calculate())
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipientCountry[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipientCountry.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            currentCountry = "USDKRW"
        case 1:
            currentCountry = "USDJPY"
        case 2:
            currentCountry = "USDPHP"
        default:
            return
        }
        
        recipientCountryLabel.text = "수취국가 : " + recipientCountry[row]
        changeUI()
    }
}
