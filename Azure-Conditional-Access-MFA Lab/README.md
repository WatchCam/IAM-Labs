# Azure Conditional Access - MFA Enforcement Lab

## Overview
This lab demonstrates the implementation of **Azure Conditional Access (CA)** to enforce **Multi-Factor Authentication (MFA)** for selectedusers using **Microsoft Entra ID**.

The objective was to simulate a real-world IAM security control by: 
- Targeting specific users
- Applying Conditional Access policies 
- Requiring MFA for cloud application access
- Verifying enforcement through sign-in logs

This mirrors how organizations protect identities against compromised credentials and unauthorized access.

---

## Security Framing (Problem -> Risk -> Control -> Outcome)

## Problem
User accounts that rely solely on usernames and passwords are vulnerable to compromise through phishing, credential reuse, and password spraying attacks.

## Risk
If credentials are compromised, attackers can gain unauthorized access to cloud applications and organizational resources without additional verification, potentially leading to data exposure or account takeover.

## Control
Azure Conditional Access was configured to enforce Multi-Factor Authentication (MFA) for selected users when accessing cloud applications. This policy applies identity-based controls to require additional verification beyond passwords.

## Outcome
By enforcing MFA through Conditional Access, the risk of unauthorized access is significantly reduced, ensuring that compromised credentials alone are insufficient to access protected resources.

---

## Environment
- Microsoft Entra ID (Azure AD)
- Azure Portal 
- Test users:
 - 'John Test'
 - Cloud applications:
  - OfficeHome (Microsoft 365)
  - Conditional Access
  - Azure Sign-in Logs 

  ---

  ## Lab Objectives
  - Create a Conditional Access policy
  - Scope the policy to specific users
  - Target all cloud applications
  - Enforce MFA using grant controls
  - Validate policy behavior via sign-in logs

  ---

  ## Conditional Access Policy Configuration

  ### 1 Policy Overview
  A Conditional Access policy was created to require MFA for test users when accessing cloud applications.

  Screenshot:
  <img width="3017" height="1917" alt="01_CA_Policy_Overview" src="https://github.com/user-attachments/assets/f1fc6e8e-877a-44d0-9967-c01d1f29f6b8" />


  ---

  ### Users Assigned 
  The policy was scoped to a test user to demonstrate targeted access control.

  Screenshot:
  <img width="4283" height="2156" alt="02_CA_Users_Assigned png" src="https://github.com/user-attachments/assets/b8200b99-e4f7-4048-8276-830a1c1e9667" />


  ---

  ### Target Resources
  All cloud applications were selected to ensure MFA enforcement across services.

  Screenshot: 
  <img width="3024" height="4032" alt="03_CA_Target_Resources png" src="https://github.com/user-attachments/assets/cb839cd1-a57b-468f-851c-f9ceb6656158" />


  ---

  ### Grant Controls
  Multi-Factor Authentication was configured as the required access control.

  Screenshot:
  <img width="2116" height="2696" alt="04_CA_Grant_MFA png" src="https://github.com/user-attachments/assets/499be19b-4e4d-4b81-93a8-88fe5195679a" />


  ---

  ### Policy State
  The policy was enabled and actively enforced.

  Screenshot:
  <img width="1577" height="2043" alt="05_CA_Policy_State png" src="https://github.com/user-attachments/assets/08fde394-2683-4024-9077-f65aedfbbfec" />


  ---

  ## Validation & Results

  ### Sign-In Attempt (Interrupted)
  A sign-in attempt by the test user triggered the Conditional Accesspolicy and required MFA.

  Screenshot: 
  <img width="3023" height="2060" alt="06_JohnTest_Signin_Interrupted png" src="https://github.com/user-attachments/assets/fe49f4a5-3032-41fd-98f1-ae60c4d319de" />


  ---

  ### Conditional Access Enforcement (Critical Evidence)
  The sign-in log confirms:
  - Policy Name: **Require MFA for Test Users**
  - Result: MFA enforced
  - Reason: Conditional Access policy

  This validates that the policy is functioning as intended.

  Screenshot:
  <img width="3018" height="1496" alt="07_CA_Policy_Evaluation_Details png" src="https://github.com/user-attachments/assets/6d21aa54-cc15-4d78-a140-6ed8a9f90f7d" />


  ---

  ## Key Takeaways
  - Conditional Access enables granular, identity-based security controls
  - MFA enforcement significantly reduces account compromise risk
  - Sign-logs provide audit-level visibility into authentication decisions
  - Policies can be scoped safely using test users before broad deployment

  ---

  ## Skills Demonstrated 
  - Identity & Access Management (IAM)
  - Azure Conditional Access
  - MFA Enforcement 
  - Security Policy Design 
  - Access Auditing & Troubleshooting
  - Microsoft Entra ID

  ---

  ## Notes
  This lab reflects real-world IAM practices used by security and identity engineers to protect enterprise environments.
