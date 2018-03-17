pragma solidity ^0.4.17;

contract Diary {
  address private owner;
  string public passPhrase;

  struct Entry {
    string content;
  }

  mapping (uint => Entry) private entries;
  uint private numEntries;

  event Entries(string entries);
  // Constructor
  function Diary() public {
    owner = msg.sender;
    numEntries = 0;
    passPhrase = "default";
  }

  function addEntry(string content) public returns (bool success) {
    if (msg.sender != owner) 
      return;
    entries[numEntries].content = content;
    numEntries++;
    return true;
  }

  function setPassPhrase(string text) public {
    passPhrase = text;
  }

  function setEntry(uint index, string content) public returns (bool success) {
    if (msg.sender != owner) return;

    Entry storage entry = entries[index];

    if (keccak256(content) != keccak256(entry.content)) {
      entry.content = content;
    }

    return true;
  }

  function getEntry(uint index) public view returns (string content) {
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
    Entries(result);
    return string(result);

  }

  function getPassPhrase() public view returns (string phrase) {
    phrase = passPhrase;
  }

  function getOwner() public view returns (address ownerAddress) {
    return owner;
  }

  function kill() public {
    if (msg.sender == owner) selfdestruct(owner);
  }
}