# Validation and Demo Checklist

Use only disposable lab accounts. Run offboarding with `-WhatIf` first and capture screenshots with no passwords, personal data, or sensitive infrastructure details visible.

## Pre-check

- Confirm the `HR`, `Finance`, `Information Technology`, and `Disabled Users` OUs exist.
- Confirm `HR-Users`, `Finance-Users`, and `IT-Users` groups exist.
- Delete or archive any earlier local `Logs\IAM-Audit.csv` so the evidence is easy to read.
- Open Active Directory Users and Computers and PowerShell side by side.

## Required test cases

| ID | Scenario | Procedure | Expected result | Evidence |
|---|---|---|---|---|
| T01 | Successful onboarding | Run `New-IAMUsers.ps1` with one new user | Enabled account is created in the correct OU, added to the requested group, and forced to change password | Console, ADUC account/group, `Success` log row |
| T02 | Duplicate protection | Run the same onboarding input again | Existing user is not modified; script records `Skipped` | Console and `Skipped` log row |
| T03 | Invalid dependency | Use a disposable row with a nonexistent OU or group | No account is created; script records `Failed` with a useful error | Console and `Failed` log row |
| T04 | Offboarding preview | Add the T01 user to `OffboardingUsers.csv`; run `Disable-IAMUsers.ps1 -WhatIf` | Proposed disable, group cleanup, and move appear; account remains unchanged | Console, unchanged ADUC state, `WhatIf` log row |
| T05 | Successful offboarding | Run `Disable-IAMUsers.ps1` and confirm the high-impact action | Account is disabled, non-default groups are removed, and object moves to Disabled Users OU | Console, ADUC account/OU/group, `Success` log row |
| T06 | Missing user | Use a clearly nonexistent username | No AD object changes; script records `Skipped` | Console and `Skipped` log row |

## Executed validation — September 13, 2026

| Scenario | Result | Evidence |
|---|---|---|
| Successful onboarding | Passed | `02-Provisioning-Verification.png` and provisioning `Success` audit row |
| Duplicate protection | Passed | `01-Duplicate-Protection-Audit.png` |
| Password-policy rejection logging | Passed | `03-Provisioning-Audit-History.png` records the domain rejection; the final script adds disabled staging and rollback based on this finding |
| Offboarding `-WhatIf` preview | Passed | Offboarding audit history records the proposed action as `WhatIf` |
| Successful offboarding | Passed | `06-Offboarding-Verification.png` and `07-Offboarding-Audit-History.png` |

The invalid-OU/group and missing-user scenarios remain available as additional regression tests; they are not represented as completed evidence in the README.

## Useful verification commands

```powershell
Get-ADUser -Identity jdoe -Properties Enabled,MemberOf |
    Select-Object SamAccountName,Enabled,DistinguishedName,MemberOf

Import-Csv .\Logs\IAM-Audit.csv |
    Format-Table TimestampUtc,Action,Username,Status,Details -AutoSize
```

## Screenshot set

1. Sanitized onboarding CSV.
2. Successful onboarding console output.
3. New user in the correct OU and security group.
4. Duplicate and controlled-failure output.
5. `-WhatIf` offboarding output.
6. Disabled account in the Disabled Users OU with access removed.
7. Structured audit log showing `Success`, `Skipped`, `Failed`, and `WhatIf`.

## 2–3 minute demo script

**0:00–0:20 — Business problem**  
“This lab automates Active Directory onboarding and offboarding. It reduces manual errors, prevents duplicate accounts, removes access during separation, and creates an audit trail.”

**0:20–0:45 — Inputs and safeguards**  
Show both CSV templates. Point out required-field validation, AD OU/group checks, secure password entry, ticket tracking, and `-WhatIf`.

**0:45–1:20 — Onboarding**  
Run one successful onboarding request. Show the user in the correct OU and group, then rerun the request to demonstrate duplicate protection.

**1:20–2:05 — Offboarding**  
Run offboarding with `-WhatIf`, confirm the account is unchanged, then execute the approved request. Show that the account is disabled, access groups are removed, and the object is in the Disabled Users OU.

**2:05–2:35 — Audit and result**  
Open `IAM-Audit.csv`. Show the timestamps, correlation IDs, actions, usernames, statuses, ticket context, and controlled failure. Close by connecting the workflow to IAM analyst, identity operations, and Active Directory support work.

Upload the finished video as an unlisted YouTube video and replace the “Coming after validation” line near the top of `README.md` with the link.
