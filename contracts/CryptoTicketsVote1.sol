pragma solidity ^0.4.16;

contract SafeMath {
     function safeMul(uint a, uint b) internal returns (uint) {
          uint c = a * b;
          assert(a == 0 || c / a == b);
          return c;
     }

     function safeSub(uint a, uint b) internal returns (uint) {
          assert(b <= a);
          return a - b;
     }

     function safeAdd(uint a, uint b) internal returns (uint) {
          uint c = a + b;
          assert(c>=a && c>=b);
          return c;
     }
}

// ERC20 standard
contract StdToken {
     function transfer(address, uint256) returns(bool);
     function transferFrom(address, address, uint256) returns(bool);
     function balanceOf(address) constant returns (uint256);
     function approve(address, uint256) returns (bool);
     function allowance(address, address) constant returns (uint256);
}

contract CryptoTicketsVote1 {
// Fields:
     address public creator = 0x0;
     bool public stopped = false;
     StdToken token; 

     mapping(address => bool) isVoted;
     mapping(address => bool) votes;
     uint public totalVotes = 0;
     uint public votedYes = 0;

// Functions:
     function CryptoTicketsVote1(address _tokenContractAddress) {
          require(_tokenContractAddress!=0);

          creator = msg.sender;
          token = StdToken(_tokenContractAddress);
     }

     function vote(bool _answer) public {
          require(!stopped);

          // 1 - should be a token holder 
          // with >1 token balance
          uint256 balance = token.balanceOf(msg.sender);
          require(balance>=5 ether);

          // 2 - can vote only once 
          require(isVoted[msg.sender]==false);

          // save vote
          votes[msg.sender] = _answer;
          isVoted[msg.sender] = true;

          ++totalVotes;
          if(_answer){
               ++votedYes;
          }
     }

     function getVoteBy(address _a) public constant returns(bool) {
          require(isVoted[_a]==true);
          return votes[_a];
     }

     function stop() public {
          require(msg.sender==creator);
          stopped = true;
     }
}


