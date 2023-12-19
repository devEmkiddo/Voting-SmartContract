// SPDX-License-Identifier: MIT

//Copyright 2023"""@devEmkiddo

pragma solidity ^0.8.0;

contract Election{
     address public owner;
     uint public startTime = block.timestamp;
     uint public endTime;

    struct Candidate{
        uint id;
        string name;
        string party;
        uint voteCount;
    }

    uint public totalVotes;
    uint candidateCount = 1;
  
  mapping (uint => Candidate) public candidateInfo;
  mapping (uint => bool) public isDisqualified;
  mapping (address => bool) public hasVoted;
  mapping (uint => bool) public isWinner;

  event Voted(
    address indexed,
    uint id
  );

  modifier cannotVoteTwice(){
    require(hasVoted[msg.sender] != true, "Cannot vote twice");
    _;
  }

  modifier onlyOwner(){
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

   modifier votingOpen() {
     require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not currently open");
     _;
}

  constructor(){
    owner = msg.sender;
    endTime = startTime + 10;
  }
 
   function addCandidate(string memory _name, string memory _party, uint _voteCount) onlyOwner public{
      candidateInfo[candidateCount] = Candidate(candidateCount,_name, _party, _voteCount);
      candidateCount++;
   }

   function vote(uint _id) public cannotVoteTwice votingOpen{
    require(_id > 0, "Invalid candidate ID");
    require(_id <= candidateCount, "Invalid candidate ID");
    if (isDisqualified[_id] == false) {

        candidateInfo[_id].voteCount++;
         totalVotes ++;
         hasVoted[msg.sender] = true;

    } else {
        revert("Candidate is disqualified");
    }
    emit Voted(msg.sender, _id);
   }

   function disqualifyCandidate(uint _id) public onlyOwner{
    require(_id > 0, "Invalid candidate ID");
    require(_id <= candidateCount, "Invalid candidate ID");
    isDisqualified[_id] = true;
   }

   function removeFromDisqualification(uint _id) public onlyOwner{
    require(_id > 0, "Invalid candidate ID");
    require(_id <= candidateCount, "Invalid candidate ID");
    isDisqualified[_id] = false;
   }

   function declareWinner(uint _id) public onlyOwner{
    require(_id > 0, "Invalid candidate ID");
    require(_id <= candidateCount, "Invalid candidate ID");
      isWinner[_id] = true;
   }
}

//Copyright 2023"""@devEmkiddo
