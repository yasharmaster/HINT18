// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import diary_artifacts from '../../build/contracts/Diary.json'

// MetaCoin is our usable abstraction, which we'll use through the code below.
// var Diary = contract(diary_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;
var Diary = contract(diary_artifacts);

window.App = {
  start: function() {
    var self = this;

    // Bootstrap the MetaCoin abstraction for Use.
    Diary.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];
      console.log(account);

        self.refreshEntries();
    });

  },

  setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
  },

  addDiaryEntry: function() {
    var self = this;

    var content = document.getElementById("new-content").value;
    console.log(content);

    this.setStatus("Adding entry... (please wait)");

    var meta;
    Diary.deployed().then(function(instance) {
      meta = instance;
      console.log("at line 62")
      return meta.addEntry(content, {from: account});
    }).then(function() {
      self.setStatus("Diary entry added!");
      self.refreshEntries();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending coin; see log.");
    });
  },

  refreshEntries: function() {
    var self = this;

    var meta;
    Diary.deployed().then(function(instance) {
      meta = instance;
      return meta.getEntries.call({from: account});
    }).then(function(value) {
      // var entries_element = document.getElementById("all-entries");
      var str_array = value.split(',');
      var ul = document.getElementById('all-entries');
      var li;
      for(var i = 0; i < str_array.length; i++) {
        // Trim the excess whitespace.
        str_array[i] = str_array[i].replace(/^\s*/, "").replace(/\s*$/, "");
        li = document.createElement('li'); 
        li.appendChild(document.createTextNode(str_array[i])); 
        ul.appendChild(li);
      }
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error getting diary entries; see log.");
    });
  }


  // refreshBalance: function() {
  //   var self = this;

  //   var meta;
  //   MetaCoin.deployed().then(function(instance) {
  //     meta = instance;
  //     return meta.getBalance.call(account, {from: account});
  //   }).then(function(value) {
  //     var balance_element = document.getElementById("balance");
  //     balance_element.innerHTML = value.valueOf();
  //   }).catch(function(e) {
  //     console.log(e);
  //     self.setStatus("Error getting balance; see log.");
  //   });
  // },

  // sendCoin: function() {
  //   var self = this;

  //   var amount = parseInt(document.getElementById("amount").value);
  //   var receiver = document.getElementById("receiver").value;

  //   this.setStatus("Initiating transaction... (please wait)");

  //   var meta;
  //   MetaCoin.deployed().then(function(instance) {
  //     meta = instance;
  //     return meta.sendCoin(receiver, amount, {from: account});
  //   }).then(function() {
  //     self.setStatus("Transaction complete!");
  //     self.refreshBalance();
  //   }).catch(function(e) {
  //     console.log(e);
  //     self.setStatus("Error sending coin; see log.");
  //   });
  // }
};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
  }

  App.start();
});