[CmdletBinding()]
Param(
   [Parameter]$AzSubscriptions = "xxxx-xxxx-xxxx-xxxx-xxxx-xxxx"
)
begin{
    $ResourceList = @()
}
process{
            foreach($AzSubscription in $AzSubscriptions){
                $AzsubscriptionDetails = $null
                $AzResourceGroupNames = $null
                $Resources = $null
                $AzsubscriptionDetails = Select-AzSubscription -SubscriptionId $AzSubscription
                Write-Host "****************************************************************************************************************"  -ForegroundColor Green  
                Write-Host "****************************************************************************************************************"  -ForegroundColor Green          
                Write-Host " Started to Collect Resources from the Subscription : $($AzsubscriptionDetails.Subscription.Name) ****" -ForegroundColor Green
                Write-Host "****************************************************************************************************************" -ForegroundColor Green
                Write-Host "****************************************************************************************************************"  -ForegroundColor Green  
                
                $AzResourceGroupNames = Get-AzResourceGroup
                foreach($AzResourceGroupName in $AzResourceGroupNames){
                    Write-Host " Started to Collect Resources from the ResourceGroup : $($AzResourceGroupName.ResourceGroupName) *****************************" -ForegroundColor Yellow
                    $SubscriptionName = $AzsubscriptionDetails.Subscription.Name
                    $SubscriptionId = $AzsubscriptionDetails.Subscription.Id
                    $Resources = Get-AzResource -ResourceGroupName $AzResourceGroupName.ResourceGroupName
                    foreach($Resource in $Resources){
                        $ResourceList += [PSCustomObject][ordered]@{
                            #ResourceID = $_.VpcId
                            SubscriptionName = $SubscriptionName
                            SubscriptionId = $SubscriptionId
                            ResourceGroupName = $Resource.ResourceGroupName
                            Name = $Resource.Name
                            ResourceID = $Resource.ResourceId
                            ResourceType = $Resource.ResourceType
                            Region = $Resource.Location
                            Tag1 =  $Resource.Tags.Tag1
                            Tag2 =  $Resource.Tags.Tag2
                            Tag3 =  $Resource.Tags.Tag3

                        }
                    }

                }
                Write-Host "******************************************************************************************************************"  -ForegroundColor Green  
                Write-Host "******************************************************************************************************************"  -ForegroundColor Green          
                Write-Host " Completed to Collect Resources from the Subscription : $($AzsubscriptionDetails.Subscription.Name) ***" -ForegroundColor Green
                Write-Host "******************************************************************************************************************" -ForegroundColor Green
                Write-Host "******************************************************************************************************************"  -ForegroundColor Green 
            }
}
end{
    $ResourceList | Export-Csv -Path .\AzResourceList.csv
}
