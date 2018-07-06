# This script is useful for when Ansible modules don't do exactly what you need
# Add a task to your playbook that calls this powershell, with no need to 
# pass any credentials around the place
#
# - name: Create load balancer
#   shell: pwsh -File "{{role_path}}/Ansible-Bridge.ps1" -Profile "{{azure_profile}}" -AdditionalParametersGoHere


# the profile being referenced by Ansible, this will be a stanza in the ~/.azure/credentials file
param (
    [string]$AzureProfile
    # AdditionalParametersGoHere
)
# function to read the credentials file
function Get-IniContent ($filePath)
{
    $ini = @{}
    switch -regex -file $FilePath
    {
        "^\[(.+)\]" # Section
        {
            $section = $matches[1]
            $ini[$section] = @{}
            $CommentCount = 0
        }
        "^(;.*)$" # Comment
        {
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = "Comment" + $CommentCount
            $ini[$section][$name] = $value
        }
        "(.+?)\s*=(.*)" # Key
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }
    return $ini
}

$content = Get-IniContent "$env:HOME/.azure/credentials"
$subscriptionID = $content[$AzureProfile]["subscription_id"]
$tenant = $content[$AzureProfile]["tenant"]
$clientID = $content[$AzureProfile]["client_id"]
$secret = $content[$AzureProfile]["secret"]

# create a credential and add the account
$credential = New-Object System.Management.Automation.PSCredential ($clientID, (ConvertTo-SecureString -String $secret -AsPlainText -Force))
Add-AzureRmAccount -TenantId $tenant -Credential $credential -ServicePrincipal -Subscription $subscriptionID

# You can now call whatever powershell you want, under the context of the service principal you use with Ansible