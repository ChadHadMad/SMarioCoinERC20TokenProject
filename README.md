# SMarioCoin – Web3 Token DApp (Ganache)

Ovaj projekt demonstrira razvoj **ERC20-like tokena** u Solidityju, njegovo pokretanje na **lokalnoj blockchain mreži (Ganache)** te interakciju s pametnim ugovorom putem **web3.js** i jednostavnog HTML sučelja.

Projekt je izrađen kao dio završnog / dodatnog zadatka s ciljem razumijevanja:
- pametnih ugovora
- lokalnog blockchaina
- interakcije frontenda s ugovorom

---

## 🔹 Korištene tehnologije

- **Solidity 0.8.x**
- **Remix IDE**
- **Ganache (Local Ethereum Blockchain)**
- **Web3.js**
- **HTML / CSS / JavaScript**

---

## 🔹 Pametni ugovor – SMarioCoin

Pametni ugovor implementira osnovne funkcionalnosti tokena:

### Osnovni podaci
- Naziv tokena: `SMarioCoin`
- Simbol: `SMC`
- Decimale: `18`
- Vlasnik ugovora: adresa koja je deployala ugovor

### Funkcionalnosti ugovora

- `balanceOf(address)` – dohvat balansa adrese
- `transfer(address to, uint256 amount)` – prijenos tokena
- `mint(address to, uint256 amount)` – stvaranje novih tokena (samo vlasnik)
- `burn(uint256 amount)` – uništavanje tokena (samo vlasnik)
- `totalSupply()` – ukupna količina tokena
- `owner()` – vlasnik ugovora

### Sigurnost
- `onlyOwner` modifier ograničava `mint` i `burn` funkcije samo na vlasnika ugovora

---

## 🔹 Ganache – Lokalna blockchain mreža

Projekt koristi **Ganache GUI** s postavkama:

- RPC server: http://127.0.0.1:7545

- Network ID: `5777`
- Automatsko rudarenje uključeno

Ganache generira:
- 10 testnih računa
- 100 ETH po računu
- privatne ključeve (za razvoj i testiranje)

Pametni ugovor je deployan s jednog od Ganache računa.

---

## 🔹 Remix IDE

Pametni ugovor je:
1. kompajliran u Remix IDE-u
2. deployan koristeći **Injected Provider / Ganache**
3. testiran putem:
 - `balanceOf`
 - `transfer`
 - `mint`
 - `burn`

Remix omogućuje direktno pozivanje funkcija ugovora i praćenje transakcija.

---

## 🔹 Web DApp (HTML + web3.js)

Izrađeno je **one-page web sučelje** koje se direktno spaja na Ganache bez MetaMaska.

### Funkcionalnosti sučelja

- automatsko povezivanje na Ganache
- prikaz aktivnog računa
- prikaz:
- imena tokena
- simbola
- ukupne količine tokena
- dohvat vlastitog balansa
- provjera balansa bilo koje adrese
- prijenos tokena
- mintanje i spaljivanje tokena (ako je račun vlasnik)

### Unos količine tokena

Korisnik **unosi osnovni iznos (npr. 1000)**  
Aplikacija automatski radi konverziju u `wei` na pozadini.

> Time se izbjegava ručno baratanje s `10^18` i olakšava korištenje.

---

## 🔹 Pokretanje projekta

### 1️⃣ Pokrenuti Ganache
- Otvoriti Ganache GUI
- Provjeriti da RPC server radi na `127.0.0.1:7545`

### 2️⃣ Deploy ugovora
- Otvoriti `SMarioCoin.sol` u Remix IDE-u
- Deploy ugovor na Ganache mrežu
- Kopirati adresu ugovora

### 3️⃣ Podesiti frontend
U HTML datoteci postaviti:
```js
const contractAddress = "0xADRESA_UGOVORA";
