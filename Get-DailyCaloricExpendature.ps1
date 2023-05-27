
function Get-DailyCaloricExpendature
{
<#
.Synopsis
   Get a rough estimate of the calories you burn on a daily basis.

.DESCRIPTION
   BMR = Basal Metabolic Rate
   Calories burned at rest.

   TDEE = Total Daily Energy Expendature
   How many calories you burn throughout the day.

   Activity Level

   Sedentary = Little to no exercise

   Lightly Active = exercise 1-3 days a week

   Moderately Active = exercise 3-4 days a week

   Very Active = exercise more than 4 days a week

   Athlete = Train more than once a day

.EXAMPLE
    
    Get-DailyCaloricExpendature -Gender Male -Age 38 -HeightInches 75 -BodyWeight 200 -ActivityLevel 'Athlete' | fl

    Get-DailyCaloricExpendature -Gender Female -Age 31 -HeightInches 65 -BodyWeight 1 -ActivityLevel 'Moderately Active' | fl
#>


    [cmdletBinding()]
    Param
    (
        [parameter(Mandatory=$true)]
        [ValidateSet("Male", "Female")]
        $Gender,
        
        [parameter(Mandatory=$true)]
        [int]$Age,

        [parameter(Mandatory=$true)]
        [int]$HeightInches,

        [parameter(Mandatory=$true)]
        [int]$BodyWeight,      
        
        [parameter(Mandatory=$true)]
        [ValidateSet("Sedentary","Lightly Active","Moderately Active","Very Active","Athlete")]
        $ActivityLevel          
    )

    if($ActivityLevel -eq 'Sedentary')
    {
        $ActivityMultiplier = '1.1'
    }

    if($ActivityLevel -eq 'Lightly Active')
    {
        $ActivityMultiplier = '1.2'
    }

    if($ActivityLevel -eq 'Moderately Active')
    {
        $ActivityMultiplier = '1.3'
    }

    if($ActivityLevel -eq 'Very Active')
    {
        $ActivityMultiplier = '1.4'
    }

    if($ActivityLevel -eq 'Athlete')
    {
        $ActivityMultiplier = '1.6'
    }


    if($Gender -eq 'male')
    {
        $BMR = 66 + (6.3 * $bodyweight) + (12.9 * $heightinches) – (6.8 * $age)
        $TDEE = $BMR * $ActivityMultiplier
    }

    if($Gender -eq 'Female')
    {
        $BMR = 655 + (4.35 * $bodyweight) + (4.7 * $heightinches) – (4.7 * $age)
        $TDEE = $BMR * $ActivityMultiplier
    }

    $FatLoss = ($TDEE) - ($TDEE * 0.2)

    [pscustomobject]@{
        BMR = [Math]::Round($BMR,0)
        TDEE = [Math]::Round($TDEE,0)
        CalForFatLoss = [Math]::Round($FatLoss,0) 
    }
}

