# Create a new service principal, needs an application and a service principal
# - obviously, handle your password in a more secure manner!!
$password = "QWERfdsaZXCV1234!"
$securePassword = ConvertTo-SecureString -Force -AsPlainText -String $password

$application = New-AzureRmADApplication -DisplayName "Test automatic application creation" -IdentifierUris "https://some.secure.website.com/"
$servicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $application.ApplicationId -Password $securePassword

# Removing the application will also remove the service principal.
$application = Get-AzureRmADApplication -DisplayNameStartWith "Test automatic application creation"
Remove-AzureRmADApplication -ObjectId $application.ObjectId -Force

# If you want to just remove the service principal you can do so, retaining the application
$servicePrincipal = Get-AzureRmADServicePrincipal -ObjectId "efd39a1e-9504-4c78-a48f-1429a569f60b"
Remove-AzureRmADServicePrincipal -ObjectId $servicePrincipal.Id -Confirm:$false

