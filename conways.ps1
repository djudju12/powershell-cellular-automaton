# OBSERVATIONS 
# ngb -> neighbours
# seed -> first generation

# Rules 
#  1 Any living cell will die if have fewer than two ngb -> underpopulation
#  2 Any living cell will die if have more than three ngb -> overpopulation 
#  3 Any dead cell with EXACTLY three living ngb will become a living cell -> reproduction
#  4 Any living cell with two or three ngb lives to next generation 

# Condensed rules
# Any live cell with two or three live ngb survives
# Any dead cell with three live ngb becomes a live cell
# all other live cells die in the next gen. 

# Now we start 
$HEITGH = 30
$WIDTH = 80
$CONE = 0x2588
$CZERO = 0x2022
# $CZERO = 0x0020


function main{
   # param($grid)
   param(
      $density,
      $time)

   # if (-Not $grid){ $grid = gen-seed}
   $grid = gen-seed -density $density

   while ($true) {
      print-grid -grid $grid
      $grid = next-grid -grid $grid
      start-sleep -Seconds $time
      clear-host 
   }
}

function gen-seed {
   param(
      $density
   )

   $grid = @()
   for ($i = 0; $i -lt $HEITGH; $i++) {
      $row = @()
      for ($j = 0; $j -lt $WIDTH; $j++) {
         $row += get-randw -density $density
      }
      $grid = $grid + , @($row) 
   }
   return $grid
}

function next-grid{
   param(
      $grid
   )
   $newgrid = @()
   for ($i = 0; $i -lt $HEITGH; $i++) {
      $row = @()
      for ($j = 0; $j -lt $WIDTH; $j++) {
         $live_ngb = cell-state -grid $grid -coord @($i, $j)
         $cell = $grid[$i][$j]
         if (($cell -eq 1) -and (($live_ngb -eq 2) -or ($live_ngb -eq 3))){
            $row += 1
         }elseif (($cell -eq 0) -and ($live_ngb -eq 3)){
            $row += 1
         }else{$row += 0}
      }
      $newgrid = $newgrid + , @($row)
   }
   return $newgrid
}

function cell-state{
   param (
      $grid, 
      $coord
   )
   $alives = 0
   $linha = $coord[0]
   $coluna = $coord[1]
   $linhal = $linha - 1 
   $linhap = $linha + 1 

   $coll = $coluna - 1 
   $colp = $coluna + 1 

   # ------------------> x
# | [HEIGTH][WIDTH]
# | (0 0 0 0 0 0 0 0 0)
# | (0 0 0 0 0 0 0 0 0)
# | (0 0 0 0 0 0 0 0 0)
# | (0 0 0 0 0 0 0 0 0)
# | (0 0 0 0 0 0 0 0 0)
# |
# \/ y

   if($linhal -ge 0){  
      if ($colp -lt $WIDTH){
         if($grid[$linhal][$colp] -eq 1) { $alives++ }
      }
      if ($coll -ge 0){
         if($grid[$linhal][$coll] -eq 1) { $alives++ }
      }
      if($grid[$linhal][$coluna] -eq 1) { $alives++ }
   }

   if ($linhap -lt $HEITGH){
      if ($colp -lt $WIDTH){
         if($grid[$linhap][$colp] -eq 1) { $alives++ }
      }
      if ($coll -ge 0){
         if($grid[$linhap][$coll] -eq 1) { $alives++ }
      }
      if($grid[$linhap][$coluna] -eq 1) { $alives++ }
   }

   if ($colp -lt $WIDTH){
      if($grid[$linha][$colp] -eq 1) { $alives++ }
   }

   if ($colp -ge 0){
      if($grid[$linha][$coll] -eq 1) { $alives++ }
   }

   return $alives
}

function print-grid{
   param(
      [Parameter(Mandatory=$true)]
      [array]
      $grid
   )

   for ($i = 0; $i -lt $HEITGH; $i++) {
      $line = ""
      for ($j = 0; $j -lt $WIDTH; $j++) {
         $bit = $grid[$i][$j]
         switch ($bit) {
            0 { $line += [char]$CZERO }
            1 { $line += [char]$CONE }
            Default {write-output "bad-bit -- Print-Grid at -> ($i,$j) bit -> $bit"}
         }
      }
      Write-Output $line
   }
}

function get-randw{
   param(
      $density
   )

   $number = Get-Random -Minimum 1 -Maximum 11
   # 10 de densidade o numero precisa ser <= 1 
   # 20 de densidade o numero precisa ser <= 2
   if ($number -le $density){$number = 1}else{$number = 0}
   return $number
}