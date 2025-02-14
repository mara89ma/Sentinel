# Fortinet Connector Template (Customized)

This repository contains a customized version of the **Fortinet Connector Template** originally provided by Microsoft on its official GitHub.

## 🔄 Changes from the Original Template

### 1. **Customizable Storage Account Name**
![image](https://github.com/user-attachments/assets/f5021d01-e236-4a8e-b2f2-4245594b9a7b)


- In the original template, the **storage account name was automatically generated** by Azure.
- In this customized version, **users can specify their own storage account name** during deployment.
- This allows better compliance with **naming conventions** and improves manageability in enterprise environments.

## 📌 Notes
The storage account name must be globally unique in Azure.
Only lowercase letters and numbers are allowed (e.g., mycustomstorage123).
Hyphens (-) are not allowed in storage account names due to Azure restrictions.

## 📝 Source
This project is based on Microsoft's **Fortinet Connector Template**, which has been customized.  
🔗 [Azure Sentinel Playbooks - Fortinet-FortiGate](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/Fortinet-FortiGate)
