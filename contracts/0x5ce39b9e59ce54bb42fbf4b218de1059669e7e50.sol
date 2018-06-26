
//Address: 0x5ce39b9e59ce54bb42fbf4b218de1059669e7e50
//Contract name: Certification
//Balance: -
//Verification Date: 3/2/2018
//Transacion Count: 0

// CODE STARTS HERE

pragma solidity ^0.4.18;

contract Certification  {

  /**
    * Address of certifier contract this certificate belongs to.
    */
  address public certifierAddress;

  string public CompanyName;
  string public Norm;
  string public CertID;
  string public issued;
  string public expires;
  string public Scope;
  string public issuingBody;

  /**
    * Constructor.
    *
    * @param _CompanyName Name of company name the certificate is issued to.
    * @param _Norm The norm.
    * @param _CertID Unique identifier of the certificate.
    * @param _issued Timestamp (Unix epoch) when the certificate was issued.
    * @param _expires Timestamp (Unix epoch) when the certificate will expire.
    * @param _Scope The scope of the certificate.
    * @param _issuingBody The issuer of the certificate.
    */
  function Certification(string _CompanyName,
      string _Norm,
      string _CertID,
      string _issued,
      string _expires,
      string _Scope,
      string _issuingBody) public {

      certifierAddress = msg.sender;

      CompanyName = _CompanyName;
      Norm =_Norm;
      CertID = _CertID;
      issued = _issued;
      expires = _expires;
      Scope = _Scope;
      issuingBody = _issuingBody;
  }

  /**
    * Extinguish this certificate.
    *
    * This can be done the same certifier contract which has created
    * the certificate in the first place only.
    */
  function deleteCertificate() public {
      require(msg.sender == certifierAddress);
      selfdestruct(tx.origin);
  }

}
