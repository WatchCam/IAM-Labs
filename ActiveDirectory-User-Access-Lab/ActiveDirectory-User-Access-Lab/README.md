# Active Directory RBAC & NTFS Access Control

An Active Directory access-management lab that maps department roles to security groups and NTFS permissions. The environment demonstrates how an IAM or IT administrator can grant access through group membership instead of assigning permissions directly to individual users.

## Business problem and risk

Organizations need a repeatable way to give employees access to departmental resources. Directly assigning permissions to individuals creates inconsistent access, makes role changes difficult, and increases the chance that users retain access they no longer need.

This lab uses organizational units, role-based security groups, and group-assigned NTFS permissions to enforce least privilege and make access easier to review and revoke.

| Risk | Control demonstrated |
|---|---|
| Users receive access outside their job function | Department-based security groups |
| Permissions are assigned inconsistently | Group-based NTFS authorization |
| Access is difficult to review | Centralized group membership |
| Role changes leave unnecessary access behind | Membership can be removed from the previous role |
| Administrative and standard identities are mixed | Separate user, department, and privileged structures |

## Solution implemented

I built a Windows Server Active Directory environment with department-based users, organizational units, and security groups. I created HR, IT Support, and Sales folders in a centralized company share and assigned NTFS permissions to the matching groups.

Users receive access because of their approved group membership—not through direct user permissions. This reflects a scalable RBAC pattern used in enterprise Active Directory environments.

## Environment

- Windows Server 2022 domain controller
- Active Directory Domain Services
- Active Directory Users and Computers
- NTFS file system and departmental folders
- Organizational units and security groups

## Access workflow

1. Create the department organizational structure in Active Directory.
2. Provision test identities using separate standard and privileged accounts.
3. Create `HR_Team`, `IT_Support`, and `Sales_Team` security groups.
4. Add each user to the group matching the approved business role.
5. Create HR, IT, and Sales folders within the company share.
6. Assign NTFS permissions to security groups rather than individual users.
7. Review group membership and folder permissions to verify the access model.

## Validation evidence

### Domain and organizational structure

![Domain overview](Screenshots/01_Aduc_%20Domain_Overview.png.jpg)

![Organizational units](Screenshots/02_ADUC_Organizational_Units.png.JPEG)

![User accounts](Screenshots/03_ADUC_User_Accounts.png.jpeg)

### Security groups and membership

![Security groups](Screenshots/04_Security_Groups_Created.png.jpg)

![Sales group membership](Screenshots/06_User_Group_Membership_Sales_2.png.jpeg)

### File-share structure

![Server file system](Screenshots/05_Server_File_System_Overview.png.jpeg)

![Company shares](Screenshots/07_CompanyShares_Folder_Created.png.jpeg)

### Department permissions

![HR permissions](Screenshots/08_NTFS_Permissions_HR_Team.png.jpeg)

![IT permissions](Screenshots/09_NTFS_Permissions_IT_Support.png.jpeg)

![Sales permissions](Screenshots/10_NTFS_Permissions_Sales_Team.png.jpeg)

## Result

The completed environment uses role-based group membership to control access to departmental resources. The design reduces direct permission assignments, supports least privilege, and gives administrators one place to review or remove access when a user changes roles.

## Skills demonstrated

- Active Directory administration
- RBAC and group-based authorization
- User and group management
- Organizational-unit design
- NTFS permissions
- Least-privilege access
- Access review and troubleshooting

## Production improvements

In a production environment, I would add:

- Separate share and NTFS permission layers using an AGDLP-style group model
- A documented access-request and manager-approval workflow
- Explicit authorized and unauthorized user test results
- Periodic access reviews for department groups
- PowerShell reporting for group membership and permission drift
- Ticket IDs and change records for every access modification
