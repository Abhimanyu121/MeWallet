import 'package:web3dart/web3dart.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart' as bitf;
import 'package:bip39/bip39.dart' as bip39;
import 'package:http/http.dart';
import'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'dart:math';
import 'dart:convert';
class ethereumWrapper {
  final abi = '''[
 {
  "constant": false,
  "inputs": [
   {
    "name": "_phone",
    "type": "string"
   },
   {
    "name": "_address",
    "type": "address"
   }
  ],
  "name": "signup",
  "outputs": [],
  "payable": false,
  "stateMutability": "nonpayable",
  "type": "function"
 },
 {
  "constant": false,
  "inputs": [
   {
    "name": "_receiver",
    "type": "string"
   }
  ],
  "name": "transfer",
  "outputs": [
   {
    "name": "",
    "type": "bool"
   }
  ],
  "payable": true,
  "stateMutability": "payable",
  "type": "function"
 },
 {
  "constant": true,
  "inputs": [
   {
    "name": "_phone",
    "type": "string"
   }
  ],
  "name": "getAddress",
  "outputs": [
   {
    "name": "",
    "type": "address"
   }
  ],
  "payable": false,
  "stateMutability": "view",
  "type": "function"
 },
 {
  "constant": true,
  "inputs": [],
  "name": "isTrue",
  "outputs": [
   {
    "name": "",
    "type": "bool"
   }
  ],
  "payable": false,
  "stateMutability": "view",
  "type": "function"
 },
 {
  "constant": true,
  "inputs": [
   {
    "name": "",
    "type": "bytes"
   }
  ],
  "name": "keys",
  "outputs": [
   {
    "name": "",
    "type": "address"
   }
  ],
  "payable": false,
  "stateMutability": "view",
  "type": "function"
 }
]''';

  dynamic newWallet(String password) async {
    var mnemonic = bip39.generateMnemonic();
    print(mnemonic);
    var seed = bip39.mnemonicToSeedHex(mnemonic);
    final cryptor = new PlatformStringCryptor();
    final String key = await cryptor.generateKeyFromPassword(password, "qwerty");
    var hdWallet = new bitf.HDWallet(seed:seed);
    print(hdWallet.privKey);
    var enpriv=  await cryptor.encrypt(hdWallet.privKey, key);
    var enmnem =  await cryptor.encrypt(mnemonic, key);
    Map<String , dynamic> wallet = new Map();
    wallet["address"] = hdWallet.address;
    wallet["pubKey"] = hdWallet.pubKey;
    wallet["privKey"] =  enpriv;
    wallet["mnemonic"] = enpriv;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('public', hdWallet.pubKey);
    await prefs.setString('private', enpriv);
    await prefs.setString('mnemonic', enmnem);
    await prefs.setString('address', hdWallet.address);
    await prefs.setBool('status',false);
    save(password,wallet);
    return true;

  }
  Future<String> fetchBalance()async {
    const pvk = '0xCA2086DDAEF198A4C2EC26FE2CEA68CC4225FF2AD415621C38747682A3220B66';
    var apiUrl = "https://ropsten.infura.io/v3/8b8d0c60bfab43bc8725df20fc660d15";
    final client = Web3Client(apiUrl, Client());
    final credentials = await client.credentialsFromPrivateKey(pvk);
    final address = await credentials.extractAddress();
    var bal =await client.getBalance(address);
    var str = bal.toString();
    return str;
  }
  Future<void> fetchAddress(String phone) async{
    const pvk = '0xCA2086DDAEF198A4C2EC26FE2CEA68CC4225FF2AD415621C38747682A3220B66';
    var apiUrl = "https://ropsten.infura.io/v3/8b8d0c60bfab43bc8725df20fc660d15";
    final client = Web3Client(apiUrl, Client());

    final contract =
    DeployedContract(ContractAbi.fromJson(abi, 'payDapp'), EthereumAddress.fromHex('0x5ce2b82f4dbed3a00caedc62ac134d92d72e699f'));
    var address= contract.function('getAddress');
    final addr = await client.call(
        contract: contract, function: address, params: ["8186f83607b8e789fac98b64101bcdf1"]);
    return addr;

  }
  Future<bool> wallet()async {
    var rng = new Random.secure();
    Credentials privatekey = EthPrivateKey.createRandom(rng);
    print(privatekey);
    var address = await privatekey.extractAddress();
    print(address.hex);
    print(privatekey);
    return true;
  }
  dynamic existing(String mnemonic, String password) async {
    var seed = bip39.mnemonicToSeedHex(mnemonic);
    print(seed);
    final cryptor = new PlatformStringCryptor();
    final String key = await cryptor.generateKeyFromPassword(password, "");
    var hdWallet = new bitf.HDWallet(seed:seed, network: null,bip32: null,p2pkh: null);
    var enpriv=  await cryptor.encrypt(hdWallet.privKey, key);
    var enmnem =  await cryptor.encrypt(mnemonic, key);
    Map<String , dynamic> wallet = new Map();
    wallet["address"] = hdWallet.address;
    wallet["pubKey"] = hdWallet.pubKey;
    wallet["privKey"] =  enpriv;
    wallet["mnemonic"] = enpriv;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('public', hdWallet.pubKey);
    await prefs.setString('private', enpriv);
    await prefs.setString('mnemonic', enmnem);
    await prefs.setString('address', hdWallet.address);
    await prefs.setBool('status',false);
    return true;

  }
  Future<bool> save(String password, Map wallet) async{
    final cryptor = new PlatformStringCryptor();
    final String key = await cryptor.generateKeyFromPassword(password, "");
    final String encryptPriv = await cryptor.encrypt(wallet["privKey"], key);
    final String encryptMnemonic = await cryptor.encrypt(wallet["mnemonic"], key);

    return true;
  }
  Future<bool> send(String phone, int value)async {
    const pvk = '0xCA2086DDAEF198A4C2EC26FE2CEA68CC4225FF2AD415621C38747682A3220B66';
    var apiUrl = "https://ropsten.infura.io/v3/8b8d0c60bfab43bc8725df20fc660d15";
    //var apiUrl = "https://testnet.matic.network";
    final client = Web3Client(apiUrl, Client(), enableBackgroundIsolate: true);
    final credentials = await client.credentialsFromPrivateKey(pvk);
    final address = await credentials.extractAddress();

    print(address.hexEip55);
    print(await client.getBalance(address));


    await client.sendTransaction(

      credentials,
      Transaction(
        to: EthereumAddress.fromHex('0x7092Fdbc448698461A3ae98488C35568f368e0AD'),
        gasPrice: EtherAmount.inWei(BigInt.from(10000000000)),
        maxGas: 21000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),

      ),
      chainId: 3,
      fetchChainIdFromNetworkId: false,
    );

    await client.dispose();

  }


}
