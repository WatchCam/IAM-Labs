# PowerShell Active Directory User Provisioning Automation Lab

## Overview

This project demonstrates how to automate Active Directory user provisioning using PowerShell and a CSV file. Instead of manually creating users, the script reads user information from a CSV file, creates the accounts, places users into the correct Organizational Unit (OU), adds them to the appropriate security group, and records all actions in a log file.

---

## Technologies Used

- Windows Server 2022
- Active Directory Domain Services (AD DS)
- PowerShell
- CSV Data Import
- Active Directory Users and Computers (ADUC)

---

## Skills Demonstrated

- PowerShell automation
- Active Directory administration
- Identity provisioning
- User account creation
- Security group management
- Organizational Unit (OU) management
- CSV data processing
- Logging and error handling
- IAM user lifecycle concepts

---

## Project Structure

```
PowerShell-AD-User-Provisioning/
│
├── Scripts/
│   └── New-IAMUsers.ps1
│
├── Input/
│   └── NewUsers.csv
│
├── Logs/
│   └── ProvisioningLog.txt
│
├── Screenshots/
│
└── README.md
```

---

## How It Works

1. Import the Active Directory module.
2. Read user information from a CSV file.
3. Verify whether each user already exists.
4. Create new Active Directory user accounts.
5. Place each user into the correct Organizational Unit.
6. Add users to the appropriate security group.
7. Record successful provisioning events in a log file.

---

## Sample Users Created

| Name | Department | Job Title |
|------|------------|-----------|
| Marcus Johnson | Finance | Financial Analyst |
| Ashley Davis | Human Resources | HR Coordinator |
| Jordan Wilson | Information Technology | Help Desk Technician |

---

## Project Results

Successfully automated:

- User account creation
- OU placement
- Security group assignment
- Logging of provisioning events
- Duplicate account detection

---

## Screenshots

### PowerShell Provisioning Script
PowerShell script used to automate Active Directory user creation, OU placement, and group assignment.

<img width="1152" height="1536" alt="Powershell Script" src="https://github.com/user-attachments/assets/dab97dff-7dde-4350-9f06-d13fc2c79e10" />


### Successful User Provisioning
Successful execution showing user accounts provisioned from CSV input and assigned to the appropriate departments.

<img width="1206" height="1608" alt="Successful Execution" src="https://github.com/user-attachments/assets/1fd1a18b-2177-45ce-b2a5-a5e80afd02cb" />


### Finance OU
Provisioned Finance users displayed in their designated Active Directory organizational unit.

<img width="3024" height="4032" alt="Finance OU" src="https://github.com/user-attachments/assets/89786e7c-7662-4bf6-8585-7abe453e8144" />


### HR OU
Provisioned HR users displayed in their designated Active Directory organizational unit.

<img width="3024" height="4032" alt="HR OU" src="https://github.com/user-attachments/assets/b546ce51-5b8f-467c-8089-739393118d4d" />


### Information Technology OU
Provisioned IT users displayed in their designated Active Directory organizational unit.


<img width="3024" height="4032" alt="Information Technology OU" src="https://github.com/user-attachments/assets/6e1ef03b-53d9-4cfd-87a5-575c4d56f9a3" />


### Provisioning Log
Provisioning log documenting successful account creation and errors generated during testing and troubleshooting.

<img width="1152" height="1536" alt="Provisioning Log" src="https://github.com/user-attachments/assets/51f43d68-372c-44c3-a2af-f8db5ddc7bbb" />


---

## Learning Outcomes

This project demonstrates practical Identity and Access Management (IAM) administration by automating the user provisioning process with PowerShell and Active Directory. It reflects common enterprise onboarding tasks performed by IAM Engineers, Identity Administrators, and Active Directory Administrators.

