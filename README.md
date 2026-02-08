# SMarioCoin Token DApp
**Autor :** *Mario Sebastian Miklošević*  
**Fakultet informatike i digitalnih tehnologija**  
**Kolegij :** *Informacijska sigurnost i blockchain tehnologije*  
**GitHub :** [here](https://github.com/ChadHadMad/SMarioCoinERC20TokenProject)

## 1. Uvod

Ovaj projekt predstavlja implementaciju jednostavnog tokena na Ethereum blockchainu pomoću pametnog ugovora napisanog u programskom jeziku **Solidity** te razvoj prateće decentralizirane aplikacije (DApp) za interakciju s ugovorom korištenjem **Web3.js** biblioteke i lokalne blockchain mreže **Ganache**.

Projekt je izrađen kao zadatak iz kolegija **Informacijska sigurnost i blockchain tehnologije** s ciljem razumijevanja osnovnih principa izrade i testiranja tokena te njihove integracije s korisničkim sučeljem.

---

## 2. Korištene tehnologije

- **Solidity (v0.8.20):** programski jezik za pisanje pametnih ugovora na Ethereum platformi.
- **Ganache:** lokalni blockchain emulator za razvoj i testiranje pametnih ugovora.
- **Web3.js (v1.10.0):** JavaScript knjižnica za komunikaciju i interakciju s Ethereum blockchainom.
- **HTML5/CSS3/JavaScript:** razvoj jednostavnog korisničkog sučelja (frontend) za DApp.
- **MetaMask ili drugi Web3 provider:** omogućava povezivanje web aplikacije s Ethereum mrežom.

---

## 3. Opis zadatka

Zadatak je zahtijevao izradu pametnog ugovora koji implementira token s osnovnim funkcionalnostima, uključujući:

- Definiranje ukupne količine tokena prilikom deploya ugovora.
- Omogućavanje prijenosa tokena između Ethereum adresa.
- Mogućnost provjere stanja (balansa) tokena na određenoj adresi.
- Implementaciju osnovnih atributa tokena (ime, simbol, decimalni broj).
- Dodatne funkcije za vlasnika ugovora kojima se upravlja ukupnom ponudom tokena:
  - **Mint:** povećanje ukupne ponude tokena.
  - **Burn:** smanjenje ukupne ponude tokena.

Projekt je također uključivao razvoj web sučelja za interakciju s ugovorom i testiranje svih funkcija na lokalnoj Ganache mreži.

---

## 4. Implementacija

### 4.1 Pametni ugovor - Solidity

Pametni ugovor `SMarioCoin` definira osnovne karakteristike i funkcionalnosti tokena:

- **Stanja:**
  - `name` — naziv tokena.
  - `symbol` — simbol tokena.
  - `decimals` — broj decimalnih mjesta tokena (standardno 18).
  - `totalSupply` — ukupna količina tokena.
  - `owner` — adresa vlasnika ugovora (kreirana prilikom deploya).
  - `balances` — mapiranje adresa na pripadajuće količine tokena.

- **Događaji:**
  - `Transfer` — bilježi prijenos tokena između adresa.
  - `Mint` — bilježi stvaranje novih tokena.
  - `Burn` — bilježi uništavanje tokena.

- **Modifikator:**
  - `onlyOwner` — omogućuje pristup određenim funkcijama isključivo vlasniku ugovora.

- **Konstruktor:**
  Postavlja vlasnika ugovora i dodjeljuje početnu ukupnu količinu tokena na njegov račun.

- **Funkcije:**
  - `balanceOf(address)` — vraća trenutno stanje tokena na danoj adresi.
  - `transfer(address, uint256)` — omogućava prijenos tokena između korisnika uz provjeru valjanosti i dovoljnog balansa.
  - `mint(address, uint256)` — vlasniku omogućuje stvaranje novih tokena i njihovo dodjeljivanje određenoj adresi.
  - `burn(uint256)` — vlasniku omogućuje smanjenje ukupne ponude tokena uništavanjem tokena sa svog računa.

#### Izvorni kod pametnog ugovora:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SMarioCoin {
    string public name = "SMarioCoin";
    string public symbol = "SMC";
    uint8 public decimals = 18;

    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) private balances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply;
        balances[owner] = totalSupply;

        emit Transfer(address(0), owner, totalSupply);
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Invalid address");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Invalid address");

        totalSupply += amount;
        balances[to] += amount;

        emit Mint(to, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        require(balances[owner] >= amount, "Not enough tokens to burn");

        balances[owner] -= amount;
        totalSupply -= amount;

        emit Burn(owner, amount);
    }
}
```
## 4.2 Frontend aplikacija - HTML i JavaScript

Frontend aplikacija izrađena je u čistom HTML-u i JavaScriptu te koristi **Web3.js** za komunikaciju s lokalnom blockchain mrežom (Ganache).

Glavne značajke web aplikacije:

- Prikaz adrese trenutno povezane Ethereum računa.
- Učitavanje i prikaz osnovnih informacija o tokenu (ime, simbol, ukupna ponuda).
- Prikaz i provjera token balansa vlastitog računa i drugih adresa.
- Mogućnost slanja tokena na druge adrese.
- Funkcionalnosti za vlasnika ugovora: mintanje i burnanje tokena putem sučelja.

### Ključni dio JavaScript koda:

```js
async function init() {
    const accounts = await web3.eth.getAccounts();
    account = accounts[0];
    document.getElementById("account").innerText = account;
}

async function loadTokenInfo() {
    document.getElementById("name").innerText = await contract.methods.name().call();
    document.getElementById("symbol").innerText = await contract.methods.symbol().call();
    document.getElementById("supply").innerText = await contract.methods.totalSupply().call();
}

async function loadMyBalance() {
    document.getElementById("myBalance").innerText = await contract.methods.balanceOf(account).call();
}

async function checkBalance() {
    const addr = document.getElementById("balanceAddr").value;
    if (!web3.utils.isAddress(addr)) {
        alert("Neispravna adresa");
        return;
    }
    document.getElementById("otherBalance").innerText = await contract.methods.balanceOf(addr).call();
}

async function transfer() {
    document.getElementById("transferStatus").innerText = "Slanje...";
    await contract.methods.transfer(
        document.getElementById("to").value,
        document.getElementById("amount").value
    ).send({ from: account });
    document.getElementById("transferStatus").innerText = "Transfer uspješan";
    loadMyBalance();
}

async function mint() {
    await contract.methods.mint(
        document.getElementById("mintTo").value,
        document.getElementById("mintAmount").value
    ).send({ from: account });
    document.getElementById("ownerStatus").innerText = "Mint uspješan";
}

async function burn() {
    await contract.methods.burn(
        document.getElementById("burnAmount").value
    ).send({ from: account });
    document.getElementById("ownerStatus").innerText = "Burn uspješan";
}

init();
```

<img src="https://raw.githubusercontent.com/ChadHadMad/Images/refs/heads/main/Screenshot%202026-02-08%20194413.png" width="600">

## 5. Testiranje

Testiranje je provedeno na lokalnoj blockchain mreži Ganache putem sljedećih koraka:

1. Deploy pametnog ugovora `SMarioCoin` s definiranom početnom količinom tokena.
2. Povezivanje frontend aplikacije s lokalnim blockchainom postavljanjem ispravne adrese pametnog ugovora.
3. Testiranje funkcionalnosti:
   - Učitavanje i prikaz osnovnih informacija o tokenu.
   - Provjera balansa vlastitog i drugih računa prije i nakon transakcija.
   - Prijenos tokena između računa.
   - Mintanje i burnanje tokena od strane vlasnika ugovora.
4. Verifikacija događaja (events) u Ganache sučelju radi potvrde ispravnog rada funkcija.  

<img src=https://raw.githubusercontent.com/ChadHadMad/Images/refs/heads/main/Screenshot%202026-02-07%20231818.png width="600">

---

## 6. Zaključak

Projekt demonstrira osnovnu implementaciju tokena u skladu s ERC-20 standardom, uključujući funkcije prijenosa, mintanja i burnanja tokena. Također prikazuje kako se pametni ugovor može integrirati s web aplikacijom koristeći **Web3.js**, omogućujući korisnicima jednostavnu interakciju s blockchainom.

Ovakva integracija je ključna za razvoj decentraliziranih aplikacija koje zahtijevaju siguran i transparentan sustav digitalnih tokena.
