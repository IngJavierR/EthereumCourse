pragma solidity ^0.5.5;

contract Votacion {
    // variables de estado
    address autoridad_electoral;
    bytes32[] candidatos;
    struct Votante {
        bool votante_autorizado;
        bool voto_emitido;
    }
    
    modifier onlyINE() {
        require(autoridad_electoral == msg.sender);
        _;
    }
    
    mapping (address => Votante) votantes;
    mapping (uint => uint) votos_recibidos;
    
    constructor(bytes32[] memory _candidatos) public {
        autoridad_electoral = msg.sender;
        candidatos = _candidatos;
    }
    
    function autorizarVotantes(address _votante) public onlyINE {
        require(!votantes[_votante].votante_autorizado);
        votantes[_votante].votante_autorizado = true;
    }
    
    function infoVotante(address _votante) public view returns (bool, bool) {
        return (votantes[_votante].votante_autorizado, votantes[_votante].voto_emitido);
    }
    
    function votar(uint _candidato) public {
        Votante storage elector = votantes[msg.sender];
        require(elector.votante_autorizado);
        require(!elector.voto_emitido);
        require(_candidato < candidatos.length);
        elector.voto_emitido = true;
        votos_recibidos[_candidato]+=1;
    }
    
    function votosObtenidos(uint _candidato) public view returns (uint) {
        return votos_recibidos[_candidato];
    }
}