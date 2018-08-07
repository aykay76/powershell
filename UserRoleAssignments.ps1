$role = "Contributor"
$resourceGroups = @('rg1','rg2','rg3')
$users = @('user1','user2','user3')
$users | ForEach-Object {
    $username = $_
    $user = Get-AzureRmADUser -UserPrincipalName $username

    $resourceGroups | ForEach-Object {
        $rgName = $_
        New-AzureRmRoleAssignment -ObjectId $user.ID -ResourceGroupName $rgName -RoleDefinitionName $role
    }
}

