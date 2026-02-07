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
  01_CA_Policy_Overview.png

  ---

  ### Users Assigned 
  The policy was scoped to a test user to demonstrate targeted access control.

  Screenshot:
  02_CA_Users_Assigned.png

  ---

  ### Target Resources
  All cloud applications were selected to ensure MFA enforcement across services.

  Screenshot: 
  03_CA_Target_Resources.png

  ---

  ### Grant Controls
  Multi-Factor Authentication was configured as the required access control.

  Screenshot:
  04_CA_Grant_Controls_MFA.png

  ---

  ### Policy State
  The policy was enabled and actively enforced.

  Screenshot:
  05_CA_Policy_State.png

  ---

  ## Validation & Results

  ### Sign-In Attempt (Interrupted)
  A sign-in attempt by the test user triggered the Conditional Accesspolicy and required MFA.

  Screenshot: 
  06_JohnTest_Signin_Interrupted.png

  ---

  ### Conditional Access Enforcement (Critical Evidence)
  The sign-in log confirms:
  - Policy Name: **Require MFA for Test Users**
  - Result: MFA enforced
  - Reason: Conditional Access policy

  This validates that the policy is functioning as intended.

  Screenshot:
  07_CA_Enforcement_Details.png

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
