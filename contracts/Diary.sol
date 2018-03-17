pragma solidity ^0.4.17;

contract Diary {
  address private owner;
  string private testPhrase;

  struct Entry {
    string content;
  }

  mapping (string => Entry) private entries;
  uint private numEntries;

  // Constructor
  function Diary(string encryptedTestPhrase) public {
    owner = msg.sender;
    numEntries = 0;
    testPhrase = encryptedTestPhrase;
  }

  function addEntry(string date, string entry) public returns (bool success) {
    if (msg.sender != owner) 
      return;
    numEntries++;
    
    entries[date].content = entry;
    return true;
  }

  function editEntry(string date, string newContent) public returns (bool success) {
    if (msg.sender != owner) 
      return;

    Entry storage entry = entries[date];

    if (keccak256(newContent) != keccak256(entry.content)) {
      entry.content = newContent;
    }

    return true;
  }

  function getEntry(string date) public view returns (string content) {
    content = entries[date].content;
  }

  // to be shown in GUI
/*  function getEntries() public view returns (string allLogins) {
    if (numEntries == 0) 
      return '';

    uint totalLength = 0;
    for (uint i=0; i < numEntries; i++) {
      totalLength = totalLength + bytes(entries[i].content).length + 1;
    }

    bytes memory result = bytes(new string(totalLength));
    uint counter = 0;
    for (i=0; i < numEntries; i++) {
      bytes memory name = bytes(logins[i].name);
      for (uint x=0; x < name.length; x++) {
        result[counter] = name[x];
        counter++;
      }

      if (i != (numEntries - 1)) {
        result[counter] = byte(',');
        counter++;
      }
    }

    return string(result);
  }*/

  function getTestPhrase() public view returns (string phrase) {
    return testPhrase;
  }

  function getOwner() public view returns (address ownerAddress) {
    return owner;
  }

  function kill() public {
    if (msg.sender == owner) 
      selfdestruct(owner);
  }
}