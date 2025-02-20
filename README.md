# Fortinet Function App Template for Sentinel (Customized)

This repository contains a customized version of the **Fortinet Connector Template** originally provided by Microsoft on its official GitHub.

## 🔄 Changes from the Original Template

### 1. **Customizable Resource Names**
- In the original template, resource names such as **Function App, App Service Plan, Storage Account, and Application Insights** were automatically generated by Azure.
- In this customized version, **users can now specify their own names for all these resources** during deployment.
- This enhances **naming convention compliance, manageability, and clarity in enterprise environments**.

### 2. **Customizable Function App, App Service Plan, Storage Account, and Application Insights Name**
![image](https://github.com/user-attachments/assets/a7d95f35-2009-4754-93d3-3faac2608edf)

- In the original template, only the Function App Name could be specified, while App Service Plan, Application Insights, and Storage Account were automatically generated and not user-configurable.
- In this customized version, users can now specify their own names for App Service Plan, Application Insights, and Storage Account in the parameters.json file before deployment.
- This enhancement allows organizations to enforce consistent naming conventions across all related Azure resources, improving manageability and compliance with internal policies.

### 3. **Updated Parameter Structure**
- Added explicit parameters for `Function App Name`, `Hosting Plan Name`, `Application Insights Name`, and `Storage Account Name`.
- Users can now **define these resource names in advance**, preventing the need for random name generation.

## 📌 Notes
All resource names are customizable in this version.
The storage account name must be globally unique in Azure.
Only lowercase letters and numbers are allowed for the storage account (e.g., mycustomstorage123).
Hyphens (-) are not allowed in storage account names due to Azure restrictions.

## 📝 Source
This project is based on Microsoft's **Fortinet Connector Template**, which has been customized.  
🔗 [Azure Sentinel Playbooks - Fortinet-FortiGate](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/Fortinet-FortiGate)

### 🔹 **What's Changed?**
1. Added **Customizable Resource Names** section.
2. Clarified that **Function App, App Service Plan, Storage Account, and Application Insights** are now customizable.
3. Updated **Deployment Instructions** to reflect the new parameters.
4. Improved **Notes** section to ensure users understand the **resource name limitations**.

Now your **README** is more informative and structured, making it clear that **all resource names** can be customized. 🚀 Let me know if you need further refinements! 😊
