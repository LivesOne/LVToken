var fs = require('fs')
var ABI = require('ethereumjs-abi')
var TX = require('ethereumjs-tx')
var KEYTHEREUM = require('keythereum')
var WEB3 = require('web3')

var recoverPrivateKey = function(password, keystore_path) {
  var keystore = JSON.parse(fs.readFileSync(keystore_path, 'utf8'));
  var privateKey = KEYTHEREUM.recover(password, keystore)
  return {addr: '0x'+keystore.address, privkey: privateKey};
}

var generateMethodCallData = function(to, value) {
  return '0x' + ABI.methodID('transfer', [ 'address', 'uint' ]).toString('hex') + ABI.rawEncode([ 'address', 'uint' ], [ to, value ]).toString('hex')
}

var sendtoken = async function(keypath, password, token, to, value) {
   var web3 = new WEB3('');

  try {
    var keystore = recoverPrivateKey(password, keypath);
    var data = generateMethodCallData(to, WEB3.utils.numberToHex(value))

    var nonce = await web3.eth.getTransactionCount(keystore.addr);
    var gasPrice = await web3.eth.getGasPrice();
    var gasLimit = await web3.eth.estimateGas({
      from: keystore.addr,
      to: token,
      data: data
    })
  } catch(e) {
    console.error(e)
    process.exit(0)
  }

  var txParams = {
    nonce: WEB3.utils.numberToHex(nonce),
    gasPrice: WEB3.utils.numberToHex(gasPrice),
    gasLimit: WEB3.utils.numberToHex(gasLimit),
    to: token, 
    value: '0x00', 
    data: data,
    // EIP 155 chainId - mainnet: 1, ropsten: 3
    chainId: 3
  }
  // console.log(txParams)
  var tx = new TX(txParams)
  tx.sign(keystore.privkey)
  var serializedTx = tx.serialize()
  // console.log(new TX(serializedTx).hash().toString('hex'))
  var rawData = '0x'+serializedTx.toString('hex')

  console.log('sending transaction')
  web3.eth.sendSignedTransaction(rawData)
  .on('transactionHash', function(hash){
    console.log('on transactionHash: '+hash)
  })
  .on('receipt', function(receipt){
    console.log('on receipt: '+ JSON.stringify(receipt))
  })
  .on('confirmation', function(confirmationNumber, receipt){
    console.log('on confirmation: '+confirmationNumber)
  })
  .on('error', console.error);

}

if (process.argv.length != 7) {
  console.log('node transfer.js keystore password token to value')
  process.exit(0)
} else {
  sendtoken(process.argv[2],
    process.argv[3], 
    process.argv[4], 
    process.argv[5],
    process.argv[6])
    // process.argv[6]+'000000000000000000')
}