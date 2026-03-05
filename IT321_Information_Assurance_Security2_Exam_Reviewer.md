IT 321 – INFORMATION ASSURANCE AND SECURITY 2  
Exam Reviewer & Mockup Examination

---

PART A: QUICK REVIEWER

Chapter 1 – Advanced Information Security

CIA Triad
- Confidentiality – Prevent unauthorized disclosure; keep data private; encryption, access controls.
- Integrity – Data accurate and unaltered; validation, checksums, digital signatures.
- Availability – Data and systems available when needed; backups, redundancy, disaster recovery.

Security Threats
- Malware – Malicious software; infects, steals, or gives remote control.
- Phishing – Stealing sensitive info by impersonating trusted sources (email, SMS, etc.).
- DDoS – Distributed Denial of Service; floods target with traffic to disrupt service.
- Data Breach – Unauthorized access to confidential data (vs. cyber attack = broader malicious activities).

Securing Networks
- Firewall – Monitors/controls traffic; barrier between trusted and untrusted networks.
- Segmentation – Dividing network into smaller segments to contain breaches and control access.
- Protocols – Rules for communication; network security protocols protect data in transit.

Protecting Data & Applications
- Encryption – Scrambles data (plaintext → ciphertext); symmetric key, column-level, tokenization.
- Access Control – Who can read/modify/delete; ACL, RBAC; principle of least privilege.
- Backups – Copy of data for recovery; full inventory, regular backups, offsite storage, test restoration; UPS, hot sites, SAN.

---

Chapter 2 – Authentication and Access Controls

Authentication
- Process – Proving identity via credentials (username/password, etc.).
- Factors: Knowledge (password, PIN), Possession (token, phone, OTP), Inherence (biometrics).
- Methods: Password-based, MFA, Biometric (fingerprint, face, iris, palm), Certificate-based, Token-based.

Remote Access
- VPN – Encrypted tunnel for remote access; types: Remote Access, Site-to-Site, Cloud, Mobile, SSL, PPTP, OpenVPN.
- RADIUS – Remote Authentication Dial-In User Service; centralized auth for dial-in/VPN/wireless; NAS talks to RADIUS server.

Managing Access
- User permissions – What tasks a user can perform.
- Best practices: RBAC, Least Privilege, regular access reviews, MFA, provisioning/deprovisioning, ACLs, monitoring, encryption, training, audits.

IAM (Identity and Access Management)
- Components: SSO, Identity Lifecycle, MFA, RBAC, PAM, Identity Federation, Access Reviews, Identity Governance, API Security, Cloud IAM.
- Examples: JumpCloud, Okta, Microsoft Azure AD, IBM Security Verify, etc.

---

PART B: TEST 1 – MULTIPLE CHOICE (25 items)

Instructions: Choose the best answer. Write the letter on your answer sheet.

---

1. What does the “C” in the CIA triad stand for?  
   A. Compliance  B. Control  C. Confidentiality  D. Cryptography
Answer: C – Confidentiality
2. Which principle ensures that data is not altered by unauthorized parties?  
   A. Availability  B. Integrity  C. Confidentiality  D. Authentication  
Answer: B – Integrity
3. Malware is short for:  
   A. Malicious software  B. Malformed software  C. Managed software  D. Multiple software  
Answer: A – Malicious software
4. Phishing attempts to steal:  
   A. Only usernames  B. Only passwords  C. Only credit card numbers  D. All of the above  
Answer: D – All of the above
5. A DDoS attack aims to:  
   A. Steal data  B. Overwhelm the target with traffic to disrupt service  C. Encrypt files  D. Spread malware  
Answer: B – Overwhelm the target with traffic to disrupt service
6. A data breach primarily involves:
   A. Unauthorized access to data  B. Only malware infection  C. Only phishing  D. Physical theft only
Answer: A – Unauthorized access to data
7. A firewall acts as:
   A. A virus scanner  B. A backup device  C. A barrier between trusted and untrusted networks  D. An encryption tool
Answer: C – A barrier between trusted and untrusted networks
8. Network segmentation helps to:
   A. Increase internet speed  B. Reduce cost  C. Simplify passwords  D. Contain breaches and prevent lateral movement of attackers
Answer: D – Contain breaches and prevent lateral movement of attackers
9. Encryption converts plaintext into:
   A. Plaintext  B. Ciphertext  C. Hash  D. Token
Answer: B – Ciphertext
10. Which is used to verify data integrity?
    A. Firewall  B. VPN  C. Checksums and digital signatures  D. Phishing
Answer: C – Checksums and digital signatures
11. Access Control Lists (ACL) and Role-Based Access Control (RBAC) are used to:
    A. Determine who can read, modify, or delete information  B. Encrypt data  C. Block malware  D. Send backups offsite
Answer: A – Determine who can read, modify, or delete information
12. A good backup plan should include:
    A. Only daily backups  B. Only offsite storage  C. Only testing  D. All of the above (inventory, regular backups, offsite storage, test restoration)
Answer: D – All of the above
13. Authentication is the process of:
    A. Encrypting data  B. Proving a user's identity  C. Backing up files  D. Segmenting the network  
Answer: B – Proving a user’s identity
14. “Something the user has” is which authentication factor?  
        A. Knowledge factor  B. Possession factor  C. Inherence factor  D. Location factor
Answer: B – Possession factor
15. Multi-Factor Authentication (MFA) requires:
    A. Only a password  B. Only a PIN  C. Multiple factors (e.g., password + OTP) to gain access  D. Only biometrics
Answer: C – Multiple factors (e.g., password + OTP) to gain access
16. Biometric authentication uses:
    A. Passwords only  B. Tokens only  C. Certificates only  D. Physical attributes (fingerprints, face, iris, etc.)
Answer: D – Physical attributes (fingerprints, face, iris, etc.)
17. VPN creates:
    A. An encrypted connection (tunnel) for remote access  B. A physical cable  C. A backup copy  D. A firewall rule
Answer: A – An encrypted connection (tunnel) for remote access
18. RADIUS provides:
    A. Only encryption  B. Only backup  C. Centralized authentication, accounting, and IP management for remote users  D. Only virus scanning
Answer: C – Centralized authentication, accounting, and IP management for remote users
19. The principle of least privilege means:
    A. Users get maximum access  B. Users get only the minimum access needed for their job  C. No access control  D. Everyone has admin rights
Answer: B – Users get only the minimum access needed for their job
20. IAM stands for:
    A. Identity and Access Management  B. Internet and Application Management  C. Information and Asset Management  D. Integrity and Authentication Method
Answer: A – Identity and Access Management
21. Single Sign-On (SSO) allows:
    A. No login at all  B. Multiple passwords per app  C. One set of credentials to access multiple applications  D. Only biometric login
Answer: C – One set of credentials to access multiple applications
22. Certificate-based authentication uses:
    A. Only username and password  B. A digital certificate (public key + CA signature)  C. Only OTP  D. Only fingerprint
Answer: B – A digital certificate (public key + CA signature)
23. Which VPN type is often used by large companies between sites?
    A. Remote Access VPN  B. Site-to-Site VPN  C. Mobile VPN  D. SSL VPN
Answer: B – Site-to-Site VPN
24. The NAS in RADIUS stands for:
    A. Network Access Server  B. Network Authentication Service  C. Normal Access System  D. Node and Storage
Answer: A – Network Access Server
25. Cipher Trust Database Protection is concerned with:
    A. Firewall rules  B. VPN setup  C. Protecting sensitive data in databases (e.g., column-level encryption)  D. Phishing prevention
Answer: C – Protecting sensitive data in databases (e.g., column-level encryption)
---

PART C: TEST 2 – ACRONYMS (15–20 items)

Instructions: Give the full meaning of each acronym. Answer key is below each number.

---

1. CIA: Confidentiality, Integrity, Availability
2. InfoSec: Information Security
3. DDoS: Distributed Denial of Service
4. DoS: Denial of Service
5. VPN: Virtual Private Network
6. RADIUS: Remote Authentication Dial-In User Service
7. MFA: Multi-Factor Authentication
8. OTP: One-Time Password
9. TOTP: Time-based One-Time Password
10. ACL: Access Control List
11. RBAC: Role-Based Access Control
12. IAM: Identity and Access Management
13. SSO: Single Sign-On
14. PAM: Privileged Access Management
15. NAS: Network Access Server
16. SSL: Secure Sockets Layer
17. PPTP: Point-to-Point Tunneling Protocol
18. PoLP: Principle of Least Privilege
19. SAML: Security Assertion Markup Language
20. UPS: Uninterruptible Power Supply
---

PART D: TEST 3 – ENUMERATION (15–20 items)

Instructions: Enumerate what is asked. Answer key is below each number.

---

1. Give the three tenets of the CIA triad.Answer: Confidentiality, Integrity, Availability
2. Enumerate at least three security threats discussed in Chapter 1.Answer: Malware, Phishing, DDoS, Data Breach (any three)

3. Give three measures or technologies for securing networks and infrastructure.Answer: Firewall, Segmentation, Protocols (also IDS/IPS, encryption, access controls)

4. Enumerate three ways to protect data and applications.Answer: Encryption, Access Control, Backups
5. Give the three main authentication factors.Answer: Knowledge factor (something you know), Possession factor (something you have), Inherence factor (something you are)
6. Enumerate at least three authentication methods.Answer: Password-based, Multi-Factor Authentication (MFA), Biometric, Certificate-based, Token-based
7. Give at least three types of VPN.Answer: Remote Access VPN, Site-to-Site VPN, Cloud VPN, Mobile VPN, SSL VPN, PPTP VPN, OpenVPN
8. Enumerate key components of a good backup plan.Answer: Full inventory of information resources; Regular backups; Offsite storage of backup data; Test of data restoration
9. Give at least three biometric authentication methods.Answer: Fingerprint scanning, Palm scanning, Facial recognition, Iris recognition, Behavioral biometrics, Voice recognition
10. Enumerate best practices for managing user permissions and access controls (give at least four).Answer: RBAC, Least Privilege, Regular access reviews, MFA, User provisioning/deprovisioning, ACLs, Monitoring and logging, Encryption, User training, Security audits
11. Give at least three IAM solution components or features.Answer: Single Sign-On (SSO), Identity Lifecycle Management, MFA, RBAC, PAM, Identity Federation, Access Reviews and Auditing, Identity Governance, API Security, Cloud IAM
12. Enumerate the steps in the authentication process.Answer: Initiation → Submission of credentials → Validation → Authentication result (success or failure)
13. Give three types of credentials in authentication.Answer: Something the user knows (password, PIN); Something the user has (token, phone); Something the user is (biometrics)
14. Enumerate objectives of malware (at least two).Answer: Provide remote control; Send spam; Steal sensitive data
15. Give at least two types of remote user access that RADIUS can support.Answer: Dial-in servers, VPN servers, Wireless access points, Managed network access switches (802.1x)
16. Enumerate two access control models mentioned in the module.Answer: Access Control List (ACL), Role-Based Access Control (RBAC)
17. Give at least two additional concepts related to backup.Answer: Uninterruptible Power Supply (UPS); Alternate or “hot” sites; SAN (Storage Area Networks); archival systems
18. Enumerate at least three IAM solution providers from the module.Answer: JumpCloud, Okta, Microsoft Azure AD, IBM Security Verify, Ping Identity, Oracle IAM, Thales SafeNet Trusted Access, HID, etc.
19. Give the three outcomes that integrity protects against.Answer: Unauthorized additions, deletions, alterations to data
20. Enumerate what availability ensures.Answer: Data and resources are accessible to authorized users when needed; involves backups, redundancy, disaster recovery
---

End of Exam Reviewer & MockupGood luck on your exam.
