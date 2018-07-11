
function Get-AzureRmCachedAccessToken()
{
  $ErrorActionPreference = 'Stop'
  
  if(-not (Get-Module AzureRm.Profile.Netcore)) {
    Import-Module AzureRm.Profile.Netcore
  }
    
  $azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
  
  $currentAzureContext = Get-AzureRmContext
  $profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azureRmProfile)
  Write-Debug ("Getting access token for tenant" + $currentAzureContext.Subscription.TenantId)
  $token = $profileClient.AcquireAccessToken($currentAzureContext.Subscription.TenantId)
  return $token
}

# Call the function to get your access token
$token = (Get-AzureRmCachedAccessToken).AccessToken

# You can then use the token to authenticate to REST APIs or whatever else you want to do
$restResponse = Invoke-RestMethod -Uri "https://management.azure.com/subscriptions/$subscriptionID/providers/microsoft.Security/securityStatuses?api-version=2015-06-01-preview" -Headers @{"Authorization" = "Bearer $token"}
$json = $restResponse.Value | ConvertTo-Json
