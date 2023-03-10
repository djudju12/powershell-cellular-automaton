import-module .\conways.ps1

$CONE = [char]0x2588
$CZERO = [char]0x2022

function get-automata{
   param(
      [Parameter(Mandatory = $true)]
      [array]
      $ConditionLive,
      
      [Parameter(Mandatory = $true)]
      [array]
      $ConditionBorn,
      
      [Parameter(Mandatory = $true)]
      [int]
      $density,
      
      [Parameter(Mandatory = $true)]
      [int]
      $time

      

   )

   $rules = @{
      "live" = $ConditionLive 
      "born" = $ConditionDie
   }

   $grid = gen-seed -density $density
   while($true){
      print-grid -grid $grid
      $grid = make-grid -grid $grid -rules $rules
      start-sleep -Seconds $time
      clear-host 
   }


}

function make-grid{
   param( 
      $grid, 
      [hashtable]
      $rules 
   )

   $newgrid = @()

   for ($i = 0; $i -lt $HEITGH; $i++) {
      $row = @()
      for ($j = 0; $j -lt $WIDTH; $j++) {
         $live_ngb = cell-state -grid $grid -coord @($i, $j)
         $cell = $grid[$i][$j]
         
         switch ($cell) {
            0 { $row += cell-rule -cell $cell -rules @($rules["born"]) -ngbs $live_ngb}
            1 { $row += cell-rule -cell $cell -rules @($rules["live"]) -ngbs $live_ngb}
            Default {write-output "bad cell at -> ($i, $j) / cell -> $cell -- mk-grid"}
         }
      
      }
      $newgrid = $newgrid + , @($row)
   }

   return $newgrid
}

function cell-rule {
   param(
      $rules,
      $ngbs
   )
 
   if($rules.Count -eq 0){ write-output "cell-rule without rules!" }
   
   foreach ($rule in $rules) {
      if($ngbs -eq $rule){return 1}
   }
   
   return 0
}