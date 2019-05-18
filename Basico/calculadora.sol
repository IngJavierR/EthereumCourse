//directiva de preprocesador
pragma solidity 0.5.7;

contract Calculadora {
    // variables de estado (privada -> default)
    uint public dato;
    address owner;
    
    // modificadores 
    
    // constructor
    constructor(uint valor_inicial) public{
        owner = msg.sender;
        dato = valor_inicial;
    }
    
    // funciones (public -> default, internal, external)
    function sumar(uint input) public {
        dato = dato + input;
    }
    
    function resta(uint input) public {
        require(input <= dato, "input es mayor a valor de estado");
        dato = dato - input;
    }
    
    function multiplicacion(uint input) public {
        uint res;
        dato = dato * input;
        require(res / dato == input, "multiplicacion overflow");
        dato = res;
    }
    
    function division(uint input) public {
        dato = dato / input;
    }
}