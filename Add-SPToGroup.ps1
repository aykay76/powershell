param (
    [string]$ServicePrincipalName = "",
    [string]$GroupName = ""
)

$group = Get-AzureADGroup -SearchString $GroupName

$sp = Get-AzureADServicePrincipal -SearchString $ServicePrincipalName

Add-AzureADGroupMember -ObjectId $group.ObjectId -RefObjectId $sp.ObjectId

