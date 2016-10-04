## Introduction
The following information is intended for the audience for the SAP on Azure Workshop in Irving, TX the week of 6/7/2016.  It provides guidance on steps needed to update the solution given to the attendees to work solely in their Azure Subscription.
The solution package will work just as it did during the workshop until 7/6/2016.  After 7/6/2016, any subsequent attempts to deploy the solution will fail because the Azure Blob Storage account where the SAP setup files are stored will no longer be accessible.  This document explains how to copy the SAP setup files to your Azure subscription and how to change the DSC configuration script to look for the files in your Azure storage account.
## Copy the SAP Setup Files
Note: The access to the installation media was granted on a temporary basis for the purpose of running this workshop.  Users of this lab instruction after the workshop will need to download the media from the SAP software download center.

Before this workshop, you will need to copy the SAP Setup Files to your own Azure storage account.  The tools you will need to do this are:
1.	AzCopy.exe (available in the .\Tools folder of the solution package you were given at the workshop)
2.	Microsoft Azure Storage Explorer (download)
The following steps will guide you through the steps needed to complete this.
1.	On your local computer, create the directory c:\sapbits.
2.	Open a Windows Command prompt window and change directory to the location where AzCopy.exe is located.
3.	Run the following command at the command prompt.   Note, this will download all the files from Ben’s storage account to your local computer and will take a few minutes depending on your connection speed (about 12G).

azcopy https://allinstallfiles.blob.core.windows.net/sapbits "C:\sapbits" "/SourceSAS:?st=2016-06-08T14%3A04%3A00Z&se=2016-07-06T05%3A00%3A00Z&sp=rl&sv=2015-04-05&sr=c&sig=wv9KgQfxgvkfczb655XnVLmlTu%2B5DPkKziwWC3ViWj0%3D" /S /Y
## Create a Storage Account to store the SAP Files
1.	Using your browser, create a storage account as explained here: https://azure.microsoft.com/en-us/documentation/articles/storage-create-storage-account/
2.	Using Storage Explorer, attach the storage account as shown
 <br/> <img src="./media/AttachStgAcct.png" style="max-width: 500px" />
3.	Next, in your storage account, create a new blob container named sapsetupfiles as shown here
  <br/> <img src="./media/CreateBlob.png" style="max-width: 500px" />
4.	Double-click on the sapsetupfiles container to show the contents of the container.  Note that currently the container is empty.
5.	Click the Upload button in the toolbar and upload the folders from c:\sapbits
   <br/> <img src="./media/UploadSapbits.png" style="max-width: 500px" />

## Update the storage account URL and SAS in the Solution Package
1.	Right-click on the sapsetupfiles container and select Get Shared Access Signature
   <br/> <img src="./media/GetSAS.png" style="max-width: 500px" />
2.	Specify a start and end time for the SAS and make sure Read and List are selected.  Click Create to create the SAS.  Choose the current time for your Start time and set the Expiry time to a duration appropriate for you.  In other words, how long do you want to be able to run this deployment script.  Ideally, this value would be parameterized and passed to the script.  Will leave that as an exercise for the audience to do
<br/> <img src="./media/SASReadListPerm.png" style="max-width: 500px" /> 
3.	Copy the URL and the Query string to notepad
4.	In Visual Studio’s Solution Explorer window, double click on the AppSrv-DSCConfiguration.ps1 file
 <br/> <img src="./media/AppSrvDSCConfig.png" style="max-width: 500px" />
5.	On line 108, replace the storage account URL with your storage account URL.  On line 110, replace the SAS with your SAS.  Recall, these were copied to notepad previously.
  <br/> <img src="./media/ReplaceStgAcctInfo.png" style="max-width: 500px" />
6.	Press Ctrl-Shift-S to save the changes
7.	Exit Visual Studio

## Deployment Steps
1.	Open PowerShell ISE
2.	Make sure your execution policy is set to RemoteSigned
Set-ExecutionPolicy -ExucutionPolicy RemoteSigned -Force
3.	Open the file in the solution package at .\SAP-Azure-RG\PS-Deploy.ps1
4.	Replace the subscription ID with yours and then run the script
   <br/> <img src="./media/ExecPS-Deploy.png" style="max-width: 500px" />






