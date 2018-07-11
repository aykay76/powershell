$cert = New-SelfSignedCertificate -CertStoreLocation "cert:\CurrentUser\My" -Subject "CN=exampleappScriptCert" -KeySpec KeyExchange
$cfp = "c:\temp\ss.pfx"
$password = "password"
$cert | Export-PfxCertificate -FilePath $cfp -Password (ConvertTo-SecureString $password -AsPlainText -Force)

$application = New-AzureRmADApplication -DisplayName "New Application Registration" `
    -HomePage "https://github.com" `
    -IdentifierUris "https://github.com" `
    -CertValue ([System.Convert]::ToBase64String($cert.GetRawCertData())) `
    -StartDate $cert.NotBefore `
    -EndDate $cert.NotAfter

$servicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $application.ApplicationId
