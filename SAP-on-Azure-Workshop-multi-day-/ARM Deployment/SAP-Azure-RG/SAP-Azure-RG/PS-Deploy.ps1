#
# Requires Azure PowerShell 1.0.3
#
# Reference: 
#   https://azure.microsoft.com/en-us/documentation/articles/resource-group-template-deploy/

# The Azure Subscription you want to use
$subscriptionId = "[YOUR SUBSCRIPTION ID]"

# The Resource Group Name and Location you want to deploy your resources to
# NOTE: If you plan to have multiple deployments you may want to append a -nn to the 
#       resource group name.  For example, "SAP-On-Azure-01" or "SAP-On-Azure-02", etc.
$resourceGrpName = "SAP-On-Azure"
$resourceGrpLoc = "East US"

#########################################################################
#### CODE BELOW SHOULD NOT BE MODIFIED
#########################################################################

$templateFile = ".\Templates\azuredeploy.json"
$templateFile = [System.IO.Path]::Combine($PSScriptRoot, $templateFile)

$artifactStagingDir = ".\bin\Debug\staging"
$artifactStagingDir = [System.IO.Path]::Combine($PSScriptRoot, $artifactStagingDir)
New-Item $artifactStagingDir -ItemType Directory -Force

$deploymentsDir = [System.IO.Path]::Combine($PSScriptRoot, ".\Deployments")
$deploymentsDirTarget = [System.IO.Path]::Combine($artifactStagingDir, ".\SAP-Azure-RG")
New-Item $deploymentsDirTarget -ItemType Directory -Force
Copy-Item $deploymentsDir -Destination $deploymentsDirTarget -Recurse -Force

# Sign-in to your Azure Subscription
Login-AzureRmAccount -SubscriptionId $subscriptionId

# Create a unique name for a storage account to be used only for deployment
do {
    $deployStgAcctName = [Guid]::NewGuid().ToString()
    $deployStgAcctName = $deployStgAcctName.Replace("-", "").Substring(0, 23)
    $isAvail = Get-AzureRmStorageAccountNameAvailability `
        -Name $deployStgAcctName | Select-Object -ExpandProperty NameAvailable
} while (!$isAvail)

# Create the deplpoyment storage account in it's own resource group 
$deployStgAcctRGName = $resourceGrpName + "-Deploy"
New-AzureRmResourceGroup -Name $deployStgAcctRGName -Location $resourceGrpLoc -Verbose -Force -ErrorAction Stop
New-AzureRmStorageAccount -ResourceGroupName $deployStgAcctRGName `
    -Type Standard_LRS `
    -Location $resourceGrpLoc `
    -Name $deployStgAcctName `
    -Verbose

# Create the resource group for the SAP deployment
New-AzureRmResourceGroup -Name $resourceGrpName -Location $resourceGrpLoc -Verbose -Force -ErrorAction Stop

# Deploy the resources for the SAP deployment
$deployResourcesScriptPath = ".\Scripts\Deploy-AzureResourceGroup.ps1"
$deployResourcesScriptPath = [System.IO.Path]::Combine($PSScriptRoot, $deployResourcesScriptPath)
& $deployResourcesScriptPath -ResourceGroupLocation $resourceGrpLoc `
    -ResourceGroupName $resourceGrpName `
    -UploadArtifacts `
    -StorageAccountName $deployStgAcctName `
    -StorageAccountResourceGroupName $deployStgAcctRGName `
    -TemplateFile $templateFile `
    -ArtifactStagingDirectory $artifactStagingDir
