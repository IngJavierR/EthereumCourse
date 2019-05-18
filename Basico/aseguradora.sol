//Contrato de seguro de viajero

//1. Definir una entidad de Gobierno (modifier)
//2. Definir una entidad que vende un seguro (modifier)
//3. El cliente solo puede comprar 1 seguro por un ether
//4. La entidad de seguros debe indicar cuando viaja o no
//5. Si estas viajando y la entidad de gobierno dice que falleciste, 
//ejecutar el pago al beneficiario por la cantidad de 2 ether

pragma solidity ^0.5.5;

contract Aseguradora1 {
    // variables de estado
    address payable owner;
    address government;
    address travelAgency;
    struct Customer {
        address payable beneficiary;
        bool hasContract;
        bool dead;
        bool paid;
        bool traveling;
    }
    
    mapping (address => Customer) public customers;
    
    constructor(address _government, address _travelAgency) public {
        owner = msg.sender;
        government = _government;
        travelAgency = _travelAgency;
    }
    
    // Modificadores
    // onlyTravelAgency
        // onlyGovernment
    modifier onlyGovernment() {
        require(government == msg.sender);
        _;
    }
    
    modifier onlyTravelAgency() {
        require(travelAgency == msg.sender);
        _;
    }
    
    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }
    
    // funciones
        // buyContract condicion: solo 1 seguro y por 1 Ether
        function buyContract (address payable _beneficiary) public payable returns (bool) {
            //validar
            require(msg.value == 1 ether, "Recuerda que el contrato vale un ether");
            //revert()
            // validamos que el usuario no sea el mismo que el beneficiario
            require(msg.sender != _beneficiary, "No puedes ser tu mismo beneficiario");
            
            //Almacenar en memoria la variable cliente
            Customer storage cliente = customers[msg.sender];
            
            //Validamos que el usuario no tenga contrato
            require(cliente.hasContract, "El usuario ya tiene contrato");
            
            cliente.beneficiary = _beneficiary;
            cliente.dead = false;
            cliente.paid = false;
            cliente.traveling = false;
            
            return true;
        }
        
        // SetViaje
        function setTraveling (address _traveler, bool _option) public onlyTravelAgency() returns (bool) {
            
            Customer storage customer = customers[_traveler];
            // Validar que tenga un contrato y que no haya fallecido
            require(customer.hasContract);
            require(!customer.dead);
            customer.traveling = _option;
            
            return customer.traveling;
        }
    
        //setDeath
        function setDeath(address _traveler) public payable onlyGovernment() returns (bool) {
            
            Customer storage customer = customers[_traveler];
            //Validamos si tiene contrato y va viajando
            require(!customer.dead);
            require(customer.hasContract);
            require(customer.traveling);
            
            //Notificamos defuncion
            customer.dead = true;
            payContract(customer.beneficiary);
            
            //Pagamos al beneficiario
            customer.paid = true;
            customer.traveling = false;
            
            return true;
        }
        
        //payContract
        function payContract(address payable _beneficiary) private {
            _beneficiary.transfer(2 ether);
        }
        
        //Cashout
        function cashOut() public isOwner() payable {
            address contrato = address(this);
            owner.transfer(contrato.balance);
        }
    
    
}

