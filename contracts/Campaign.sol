pragma solidity ^0.4.25;

contract CampaignFactory {
    address[] public deployedCampaigns;
    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    function getDeployedCampaigns() public view returns(address[]) {
        return deployedCampaigns;
    }
}


contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    uint len = 0;

    constructor(uint minimum, address creator) public {
        manager=creator;
        minimumContribution=minimum;
    }

    mapping(address => bool) public futureUse;

    function Contribute(bool ask) public payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
        if(ask == true){
            futureUse[msg.sender] = true;
            len++;
        }
        else{
            futureUse[msg.sender] = false;
        }

    }
    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0

            });
        requests.push(newRequest);
    }
    function approveRequest(uint index) public {
        Request storage request = requests[index];
        require(futureUse[msg.sender] == false);
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        require(!request.complete);
        require((request.approvalCount+len) > (approversCount/2));
        request.complete = true;
        request.recipient.transfer(request.value*1000000000000000000);
    }
}