$resourceGroupName = ""
$storageAccountName = ""
$container = ""
$source = ""
$dest = ""

$storageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName)[0].value

$Context = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey  
Start-AzureStorageBlobCopy -SrcContainer $container -DestContainer $container -SrcBlob $source -DestBlob $dest -Context $Context -DestContext $Context 
Remove-AzureStorageBlob -Container $container -Context $Context -Blob $source 
