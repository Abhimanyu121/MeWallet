import 'package:web3dart/web3dart.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart' as bitf;
import 'package:bip39/bip39.dart' as bip39;
import 'package:http/http.dart'  as http;
import'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';
import 'database.dart';
import 'package:convert/convert.dart';
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

  dynamic newWallet(String password,String number) async {
    var url = 'https://api.blockcypher.com/v1/eth/main/addrs';
    var response = await http.post(url, body: {"token":"3011e4b41f604976ae44f36f608ed973"});
    var pjson=jsonDecode(response.body);
    print(response.body);
    final cryptor = new PlatformStringCryptor();
    final String key = await cryptor.generateKeyFromPassword(password, "qwerty");
    var enpriv=  await cryptor.encrypt(pjson['private'], key);
    Map<String , dynamic> wallet = new Map();
    wallet["address"] = "0x"+pjson['address'];
    wallet["pubKey"] = pjson['public'];
    wallet["privKey"] =  enpriv;
    wallet['password'] = password;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('public', pjson['public']);
    await prefs.setString('private', enpriv);
    await prefs.setString('password', password);
    await prefs.setString('number',number );
    await prefs.setString('address', "0x"+pjson['address']);
    print(prefs.getString('address')+" at prefs");
    await prefs.setBool('status',true);
    return wallet;

  }
  Future<int> fetchTransactionNumbers() async{
    final cryptor = new PlatformStringCryptor();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = await cryptor.generateKeyFromPassword(prefs.getString('password'), "qwerty");
    var privateKey;
    try {
      final String decrypted = await cryptor.decrypt(prefs.getString('private'), key);
      privateKey = decrypted;
      print(decrypted); // - A string to encrypt.
    } on MacMismatchException {
      // unable to decrypt (wrong key or forged data)
    }
    //const pvk = '0xCA2086DDAEF198A4C2EC26FE2CEA68CC4225FF2AD415621C38747682A3220B66';
    var pvk = privateKey;
    var apiUrl = "https://ropsten.infura.io/v3/8b8d0c60bfab43bc8725df20fc660d15";
    final client = Web3Client(apiUrl, http.Client());
    final credentials = await client.credentialsFromPrivateKey(pvk);
    final address = await credentials.extractAddress();
    print(address);
    int num = await client.getTransactionCount(address);
    return num;

  }
  Future<String> fetchBalance()async {
    final cryptor = new PlatformStringCryptor();
    var str;
    await SharedPreferences.getInstance().then((prefs)async {final String key = await cryptor.generateKeyFromPassword( prefs.getString('password'), "qwerty");
    var privateKey;
    try {
    final String decrypted = await cryptor.decrypt(prefs.getString('private'), key);
    privateKey = decrypted;
    print(decrypted); // - A string to encrypt.
    } on MacMismatchException {
    // unable to decrypt (wrong key or forged data)
    }
    //const pvk = '0xCA2086DDAEF198A4C2EC26FE2CEA68CC4225FF2AD415621C38747682A3220B66';
    var pvk = privateKey;
    //const pvk = '0xCA2086DDAEF198A4C2EC26FE2CEA68CC4225FF2AD415621C38747682A3220B66';
    var apiUrl = "https://ropsten.infura.io/v3/8b8d0c60bfab43bc8725df20fc660d15";
    final client = Web3Client(apiUrl, http.Client());

    final credentials =  await client.credentialsFromPrivateKey(pvk);
    final address = await credentials.extractAddress();

    var bal =await client.getBalance(address);
    var abc = bal.getInEther.toString();
    str = abc;});

    return str;
  }
  Future<dynamic > fetchAddress(String phHash) async{

    //const pvk = '0xCA2086DDAEF198A4C2EC26FE2CEA68CC4225FF2AD415621C38747682A3220B66';
    var apiUrl = "https://ropsten.infura.io/v3/8b8d0c60bfab43bc8725df20fc660d15";
    final client = Web3Client(apiUrl, http.Client());

    final contract =
    DeployedContract(ContractAbi.fromJson(abi, 'payDapp'), EthereumAddress.fromHex('0xe892035db0f1230b9396fcd47e0aaebafdd32fa4'));
    var address= contract.function('getAddress');
    final addr = await client.call(
        contract: contract, function: address, params: [phHash]);
    print(addr.toString());
    return addr.toString();

  }

  dynamic existing(String mnemonic, String password) async {
    var seed = bip39.mnemonicToSeedHex(mnemonic);
    print(seed);
    final cryptor = new PlatformStringCryptor();
    final String key = await cryptor.generateKeyFromPassword(password, "");
    var hdWallet = new bitf.HDWallet(seed:seed);
    var enpriv=  await cryptor.encrypt(hdWallet.privKey, key);
    var enmnem =  await cryptor.encrypt(mnemonic, key);
    Map<String , dynamic> wallet = new Map();
    wallet["address"] = hdWallet.address;
    wallet["pubKey"] = hdWallet.pubKey;
    wallet["privKey"] =  enpriv;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('public', hdWallet.pubKey);
    await prefs.setString('private', enpriv);
    await prefs.setString('mnemonic', enmnem);
    await prefs.setString('address', hdWallet.address);
    await prefs.setBool('status',true);
    return true;

  }

  Future<bool> send(String phone, int value)async {
    final cryptor = new PlatformStringCryptor();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = await cryptor.generateKeyFromPassword(prefs.getString('password'), "qwerty");
    var privateKey;
    try {
      final String decrypted = await cryptor.decrypt(prefs.getString('private'), key);
      privateKey = decrypted;
      print(decrypted); // - A string to encrypt.
    } on MacMismatchException {
      // unable to decrypt (wrong key or forged data)
    }
    //const pvk = '0xCA2086DDAEF198A4C2EC26FE2CEA68CC4225FF2AD415621C38747682A3220B66';
    var pvk = privateKey;
    //const pvk = '0xCA2086DDAEF198A4C2EC26FE2CEA68CC4225FF2AD415621C38747682A3220B66';
    var apiUrl = "https://ropsten.infura.io/v3/8b8d0c60bfab43bc8725df20fc660d15";
    var content = new Utf8Encoder().convert(phone);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    var hash =  hex.encode(digest.bytes);
    var add = await fetchAddress(hash);
    var recAddress = add[0];
    //var apiUrl = "https://testnet.matic.network";
    final client = Web3Client(apiUrl, http.Client(), enableBackgroundIsolate: true);
    final credentials = await client.credentialsFromPrivateKey(pvk);
    final address = await credentials.extractAddress();

    print(address.hexEip55);
    print(await client.getBalance(address));

    print(recAddress);
    await client.sendTransaction(

      credentials,
      Transaction(
        to: EthereumAddress.fromHex(add),
        gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
        maxGas: 21000,
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, value),

      ),
      chainId: 3,
      fetchChainIdFromNetworkId: false,
    );

    await client.dispose();
    return true;

  }
  Future<bool> mapHash(String hash, String address)async{
    var apiUrl = "https://ropsten.infura.io/v3/8b8d0c60bfab43bc8725df20fc660d15";
    final client = Web3Client(apiUrl, http.Client());
    final contract =
    DeployedContract(ContractAbi.fromJson(abi, 'payDapp'), EthereumAddress.fromHex('0xe892035db0f1230b9396fcd47e0aaebafdd32fa4'));
    var mapp= contract.function('signup');
    final addr = await client.call(
        contract: contract, function: mapp, params: [hash,EthereumAddress.fromHex(address)]);
    print(addr.toString());
    return true;

  }


}
