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

$WIDTH = 200 
$HEITGH = 200


function main{
   param($seed)

   if (-Not $seed){ $seed = gen-seed}

   while ($true) {
      $grid = gen-grid -seed $seed
      print-grid -grid $grid
   }
}

function gen-grid{
   param(
      [Parameter(Mandatory=$true)]
      [array]
      $grid
   )

   for ($i = 0; $i -lt $array.Count; $i++) {
      for ($j = 0; $j -lt $array.Count; $j++) {
         $alive = living-cells -grid $grid
         switch ($alive) {
            condition {  }
            condition {  }
            condition {  }
            Default {}
         }            
      }
   }

}