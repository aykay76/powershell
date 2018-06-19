# if (!$env:AGENT_ID)
# {
#     if ((Get-AzureRmContext).Tenant.Id -eq $null)
#     {
#         Login-AzureRmAccount | Out-Null
#     }
# }

Get-AzureRmResourceGroup | ForEach-Object {
    $resourceGroupName = $_.ResourceGroupName

    $count = (Get-AzureRmResource | Where-Object { $_.ResourceGroupName -eq $resourceGroupName } | Measure-Object).Count

    "$SubscriptionName`t$resourceGroupName`t$count"
}
