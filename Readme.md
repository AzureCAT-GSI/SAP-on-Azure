# SAP on Azure Workshop

Last Update May 19 2017

## A workshop covering SAP on Azure. Consists of a combination of lectures and hands on labs demonstrating core concepts.

## Learning Objectives
*
* 

## Pre-Requisites
* Azure Subscription
* Azure SDK
* PowerShell


## Sessions
### [SAP on Azure Update](./Presentations/01_SAPHANAonAzure2016.pptx?raw=1)
This session sets the stage by reviewing the business benefit of SAP on Azure with highlights of Azure hyper scale, flexibility, ease of deployment, and cost saving, then follow with updates on SAP on Azure capabilities for both the classic SAP Business Suites and SAP HANA workloads

### [Azure Compute, Storage, Networking, and Monitoring for SAP](./Presentations/02_Azure_Compute_Storage_Network_for_SAP.pptx?raw=1)
Azure Compute, Storage, and Networking are foundational components to an IaaS solution design.  This session equips the Solution Architect with essential knowledge to leverage compute, storage options for scalability and performance; provides recommended practices in Azure network design to extend your on-premises network to Azure with manageability, availability, and security pertaining to the SAP workload.   From VM series and size selection to leveraging a load balancer to improve VM availability and scalability, from blob storage redundancy and optimal layout to storage account quotas and limitations, audiences will learn the essential knowledge to weave together a reliable and performance oriented infrastructure for SAP.  Audiences also learn the VM extension that enables Azure infrastructure logs integration with SAP CCMS and practices for storing log data, tools for analysis, and how to configure rules and alerts to help thwart off potential problems for your end-users

### [Architecting Virtual Machine & Hybrid Solutions](./Presentations/03_Architecting_VM_Hybrid_Solutions.pptx?raw=1)
Building on the foundational knowledge gained from the Azure Compute, Storage, and Network session, we venture into extending your on-premises data center to the cloud by designing identity solution for both Windows and Linux servers, SQL Server database high availability and business continuity strategy, and extending storage to the cloud.  We will further explore Azure Backup solution configured for an SAP system.  In this session we will also introduce the use of Azure Site Recovery (ASR) to protect VM solutions 

### [SAP Business Suites Netweaver on Azure Architecture Design](./Presentations/04_SAP_Netweaver_on_Azure_ADS?raw=1)

During presales, an SAP solution architect need to gather customer requirements and come up with the solution architecture to run SAP.  This session discusses certified SAP products, licensing, support arrangement, and future roadmap.  We will also explore primary scenarios for running SAP NW on Azure, their backup/restore and HA/DR options. Topics discussed in this session include:
* The process and considerations in conducting an SAP NW on Azure architecture design session
* Planning and capacity – Describe cross premises network connectivity options, capacity planning for compute and storage, SAP sizing methods
* Windows Server Active Directory, Domain Services replication to Azure
* Azure backup for SAP NW systems
* SAP/Oracle on Azure – SAP/Microsoft support for Oracle as a RDBMS, HA/DR solution
* SAP/SQL on Azure - SAP/Microsoft support for SQL as a RDBMS, HA/DR solution
* Backup
* Large database files migration from on-premises to Azure
* Estimate solution cost with the Azure cost calculator

### [SAP Business Suites NW Lift and Shift case study](./Presentations/Lift_and_Shift_CaseStudy.pptx?raw=1)
Given a customer case with an on-premises SAP ECC system to migrate its Production environment to Azure. Leverage information learned, participants will think through the customer’s situation and devise a solution with Azure network, compute, and storage to meet the stated requirements. For this customer, the system is critical in their business so it needs to have HA/DR consideration. Also the audiences will work out the estimate cost of the solution.

### Building SAP systems via Azure Portal

After having gone through the design of an SAP on Azure infrastructure, we lead the audiences through the building process of an SAP Netweaver system with the use of the Azure Management Portals.  We recap the build steps, highlight recommended practices while audiences have the opportunity to share their on-premises and other cloud build experiences as well as asking questions.

### [Infrastructure as Code](./Presentations/05_Infrastructure_as_Code.pptx?raw=1)

Azure offers facility via ARM template and DSC for build automation.  In this session we walk the audiences through the ARM management concept, the way to author Jason templates and script Desired States Configuration for building an infrastructure for SAP

### [SAP Silent Install](./Presentations/06_SAP_Silent_Install.pptx?raw=1)

SAP Netwaever Business Suites Software Deployment Manger supports a silent installation of SAP database and application servers.  This session walk the audiences through the process of capturing installation parameters and execution of the silent install for a sample SAP system

### [SAP HANA Architecture design session](./Presentations/07_SAP_HANA_on_Azure_Architectural_Design_Session_ADS.pptx?raw=1)

SAP HANA is an SAP In-Memory database that currently supports a selected set of SAP analytics and ERP applications.  Its solution architecture although has some resemblance to the classic NW applications but has noticeable differences in HA/DR implementation.  This session discusses planning and design considerations specific to the SAP HANA database below:
* Gather customer’s requirements in terms of system sizes, authentication, availability, disaster recovery, on-premises SAP landscape, and network
* SAP HANA on Azure deployment options
* Authentication for SAP HANA/SUSE OS on Azure
* Compute capacity sizing
* Storage accounts and drive volumes planning for SAP HANA
* HA and DR strategy for SAP HANA as a database server
* Backup

### [SAP BW on HANA case study](./Presentations/08_SAP_HANA_on_Azure_Case_Study.pptx?raw=1)

### [Building SAP HANA system via Azure portal](./Presentations/09_Building_SAP_HANA_in_Azure.pptx?raw=1)
This session takes the audiences through the experience of building an SAP HANA system over the Azure Management portals.  We recap the build steps, highlight recommended practices while audiences have the opportunity to share their on-premises and other cloud build experiences as well as asking questions.

### Solutions Building

This session takes us through all above the technology and re-focus on the business aspect of leveraging Azure as a revenue generation engine.  We will introduce our thoughts on the Azure practice.  Partners with larger representation at this workshop can prearrange with us to have breakout sessions to step through the practice baselining and the approach we use to create Azure offers and repeatable solutions for your practices.  

## Code of Conduct
This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
