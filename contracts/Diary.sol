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

  function addEntry(string content) public returns (bool success) {
    if (msg.sender != owner) 
      return;
    entries[numEntries].content = content;
    numEntries++;
    return true;
  }

  function setEntry(uint index, string content) public returns (bool success) {
    if (msg.sender != owner) return;

    Entry storage entry = entries[index];

    if (keccak256(content) != keccak256(entry.content)) {
      login.content = content;
    }

    return true;
  }

  function getEntry(string index) public view returns (string content) {
    content = entries[index].content;
  }

  function getEntries() public view returns (string allEntries) {
    if (numEntries == 0) return '';

    uint totalLength = 0;
    for (uint i=0; i < numEntries; i++) {
      totalLength = totalLength + bytes(entries[i].content).length + 1;
    }

    bytes memory result = bytes(new string(totalLength));
    uint counter = 0;
    for (i=0; i < numEntries; i++) {
      bytes memory content = bytes(entries[i].content);
      for (uint x=0; x < content.length; x++) {
        result[counter] = content[x];
        counter++;
      }

      if (i != (numEntries - 1)) {
        result[counter] = byte(',');
        counter++;
      }
    }

    return string(result);
  }

  function getTestPhrase() public view returns (string phrase) {
    return testPhrase;
  }

  function getOwner() public view returns (address ownerAddress) {
    return owner;
  }

  function kill() public {
    if (msg.sender == owner) selfdestruct(owner);
  }
}