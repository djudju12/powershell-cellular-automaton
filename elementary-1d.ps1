Import-Module .\configure.ps1

function rule{
   param (
      # Parameter help description
      [Parameter(Mandatory=$true)]
      [int]
      $width,
      [int]
      $ruleCode,
      [array]
      $firstGen,
      [switch]
      $random
   )
   $rule = choose-rule -ruleCode $ruleCode
   
   if (-Not $firstGen){
      $gen = first_gen -width $width -random:$random
   }else{
      $gen = $firstGen
   }
   
   for ($i = 0; $i -lt $width; $i++) {
      $filledGen = fill -gen $gen
      write-output $filledGen
      $tempGen = new_gen -gen $gen -width $width -rule $rule
      $gen = $tempGen
   }
}

function first_gen{
   param(
      [Parameter(Mandatory=$true)]
      [int]
      $width,
      [bool]
      $random
   )

   $gen = @()
   for ($i = 0; $i -lt $width; $i++) {
      if ($random){
         $gen += get-random -Minimum 0 -Maximum 2
      }else{
         $gen += 0
         if ($i -eq [math]::floor($width/2)) { $gen[$i] = 1 }
      }
   }
   return $gen
}

function new_gen{
   param(
      [Parameter(Mandatory=$true)]
      [array]
      $gen,
      [Parameter(Mandatory=$true)]
      [int]
      $width,
      [Parameter(Mandatory=$true)]
      [hashtable]
      $rule
   )

   $tempGen = @()
   $tempGen += 0
   for ($n = 1; $n -lt $width-1; $n++) {
      $neighborhood = neighborhood -currentGen $gen -ICell $n
      $tempGen += $rule[$neighborhood]
   }
   $tempGen += 0

   return $tempGen
}

function neighborhood{
   param(
      $currentGen, 
      $ICell
   )
   $nb = [string]$currentGen[$ICell-1] + [string]$currentGen[$ICell] + [string]$currentGen[$ICell+1]
   return $nb
}

function fill{
   param(
      [Parameter(Mandatory=$true)]
      [array]
      $gen
   )
   $filled_gen = @()
   foreach ($val in $gen) {
      switch ($val) {
         0 { $filled_gen += [char]$CZERO }
         1 { $filled_gen += [char]$CONE }
         Default { write-output "Bad bit -- fill" + $val}
      }   
   }
   $filled_gen = $filled_gen -join "" 
   return $filled_gen
}

function choose-rule {
   param (
      [Parameter(Mandatory=$true)]
      [int]
      $ruleCode
   )
   $rule = convert-i2b -dado $ruleCode -bytes 2
   $hash = [ordered]@{
      '000' = $rule[7]
      '001' = $rule[6]
      '010' = $rule[5]
      '011' = $rule[4]
      '100' = $rule[3]
      '101' = $rule[2]
      '110' = $rule[1]
      '111' = $rule[0]
   }
   return $hash
}

function convert-i2b {
   param (
      [Parameter(Mandatory=$true)]
      $dado,
      [int]
      $bytes,
      [int]
      $bits
   )
   
   $dado = [System.Convert]::ToString($dado, 2)
   if ($bytes){
      return $dado.PadLeft($bytes*4,"0")
   }
   elseif ($bits){
      return $dado.PadLeft($bytes,"0")
   }
   return $dado
}