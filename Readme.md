# SAP on Azure Workshop

Last Update June 23, 2017

## A workshop covering SAP on Azure. Consists of a combination of lectures and hands on labs demonstrating core concepts.

## Learning Objectives
* Overview and deep dive on foundamental pillars of Azure required for SAP on Azure workloads, covering Storage, Compute and Networking in detail
* Understanding Azure capabilities and certified solutions for SAP NetWeaver architectures on Azure
* Deep Dive and architecture samples for SAP HANA on Azure, including Azure Large Instances   

## Sessions
### [SAP on Azure Update](./Presentations/01_SAP_on_Azure_Intro.pptx?raw=1)
This session sets the stage by reviewing the current state of the Azure platform, business benefit of SAP on Azure with highlights of Azure hyper scale, flexibility, ease of deployment, and cost saving, then follow with updates on SAP on Azure capabilities for both the classic SAP Business Suites and SAP HANA workloads

### [Azure Compute, Storage, Networking, and Monitoring for SAP](./Presentations/02_Azure_Compute_Storage_Network_for_SAP.pptx?raw=1)
Azure Compute, Storage, and Networking are foundational components to an IaaS solution design.  This session equips the Solution Architect with essential knowledge to leverage compute, storage options for scalability and performance; provides recommended practices in Azure network design to extend your on-premises network to Azure with manageability, availability, and security pertaining to the SAP workload.   From VM series and size selection to leveraging a load balancer to improve VM availability and scalability, from blob storage redundancy and optimal layout to storage account quotas and limitations, audiences will learn the essential knowledge to weave together a reliable and performance oriented infrastructure for SAP.  Audiences also learn the VM extension that enables Azure infrastructure logs integration with SAP CCMS and practices for storing log data, tools for analysis, and how to configure rules and alerts to help thwart off potential problems for your end-users

### [Architecting IaaS & Hybrid Solutions](./Presentations/03_Architecting_IaaS_and_Hybrid_Solutions.pptx?raw=1)
Building on the foundational knowledge gained from the Azure Compute, Storage, and Network session, we venture into extending your on-premises data center to the cloud by designing identity solution for both Windows and Linux servers, SQL Server database high availability and business continuity strategy, and extending storage to the cloud.  We will further explore Azure Backup solution configured for an SAP system.  In this session we will also introduce the use of Azure Site Recovery (ASR) to protect VM solutions 

### [SAP Business Suites Netweaver on Azure Architecture Design](./Presentations/04_SAP_Netweaver_on_Azure_ADS.pptx?raw=1)

During presales, an SAP solution architect need to gather customer requirements and come up with the solution architecture to run SAP.  This session discusses certified SAP products, licensing, support arrangement, and future roadmap.  We will also explore primary scenarios for running SAP NW on Azure, their backup/restore and HA/DR options. Topics discussed in this session include:
* The process and considerations in conducting an SAP NW on Azure architecture design session
* Describing cross premises network connectivity options, capacity planning for compute and storage, SAP sizing methods
* Windows Server Active Directory, Domain Services replication to Azure
* Azure backup for SAP NW systems
* Backup
* Large database files migration from on-premises to Azure
* Estimate solution cost with the Azure cost calculator

### [SAP Business Suites NW Lift and Shift case study](./Presentations/05_SAP-NW-NonHANA_Case-Study.pptx?raw=1)
Given a customer case with an on-premises SAP ECC system to migrate its Production environment to Azure. Leverage information learned, participants will think through the customer's situation and devise a solution with Azure network, compute, and storage to meet the stated requirements. For this customer, the system is critical in their business so it needs to have HA/DR consideration. Also the audiences will work out the estimate cost of the solution.

### [SAP HANA Architecture design session](./Presentations/06_SAP_HANA_on_Azure_ADS.pptx?raw=1)

SAP HANA is an SAP In-Memory database that currently supports a selected set of SAP analytics and ERP applications.  Its solution architecture although has some resemblance to the classic NW applications but has noticeable differences in HA/DR implementation.  This session discusses planning and design considerations specific to the SAP HANA database below:
* Gather customer's requirements in terms of system sizes, authentication, availability, disaster recovery, on-premises SAP landscape, and network
* SAP HANA on Azure deployment options
* Authentication for SAP HANA/SUSE OS on Azure
* Compute capacity sizing
* Storage accounts and drive volumes planning for SAP HANA
* HA and DR strategy for SAP HANA as a database server
* Backup

### [SAP HANA case study](./Presentations/07_SAP_HANA_Case_Study.pptx?raw=1)

Design a SAP HANA solution and present them to the target customer in a 10-minute chalk-talk format with quotes

### [Business Continuity for SAP on Azure](./Presentations/08_SAP_Business_Continuity.pptx?raw=1)
Deep dive into business continuity for SAP on Azure, covering both High Availability and Disaster Recovery on the different layers for database, application servers and SAP Central Services. 
* SAP/Oracle on Azure, SAP/Microsoft support for Oracle as a RDBMS, HA/DR solution
* SAP/SQL on Azure - SAP/Microsoft support for SQL as a RDBMS, HA/DR solution
* SAP/HANA and HANA on Azure Large Instances  

### [Infrastructure as Code](./Presentations/09_Infrastructure_as_Code?raw=1)

Azure offers facility via ARM template and DSC for build automation.  In this session we walk the audiences through the ARM management concept, the way to author Json templates and script Desired States Configuration for building an infrastructure for SAP. We are also showing the SAP on Azure Reference Architecture which enables repeatable, consistent deployment of Azure infrastructure for SAP  

### Solutions Building

This session takes us through all above the technology and re-focus on the business aspect of leveraging Azure as a revenue generation engine.  We will introduce our thoughts on the Azure practice.  Partners with larger representation at this workshop can prearrange with us to have breakout sessions to step through the practice baselining and the approach we use to create Azure offers and repeatable solutions for your practices.  

## Code of Conduct
This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
