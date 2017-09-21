if ($(Get-Host).Name.Contains("ISE")){

    start-process PowerShell.exe -argument $MyInvocation.MyCommand.Definition
    Return

}

function pixel(){

    [Console]::SetCursorPosition(0, 30)
    [char]0x2591
    [char]0x2592
    [char]0x2593
    [char]0x2588

}

[Hashtable]$DisplaySize = @{ width = 70; height = 50}
[Console]::CursorVisible = $false
[Console]::Title = "!Roguelike Zombie!"
[Console]::BufferWidth = $DisplaySize.width
[Console]::BufferHeight = $DisplaySize.height
[Console]::WindowWidth = $DisplaySize.width
[Console]::WindowHeight = $DisplaySize.height

Class Level{

    [System.Array]$map

    Level([int]$width, [int]$height){
        $this.map = New-Object "object[][]" $width,$height
        for ($x = 0; $x -lt $this.map.Count; $x++) {
            for ($y = 0; $y -lt $this.map[$x].Count; $y++) {

                $this.map[$x][$y] = [Ground]::new()

                if( $x -eq 0 -or $y -eq 0 ){ 
                    $this.map[$x][$y] = [Wall]::new()
                }
                if( $x -eq $this.map.Count -1 -or $y -eq $this.map[$x].Count -1 ){ 
                    $this.map[$x][$y] = [Wall]::new()
                }
            }
        }
    }

    Show(){
        for ($x = 0; $x -lt $this.map.Count ; $x++) {
            for ($y = 0; $y -lt $this.map[$x].Count; $y++) {
                [Console]::SetCursorPosition($x, $y)
                $object = $this.map[$x][$y]
                $object.Show()
            }
        }
    }
}

Class Ground{
    [char]$char = "."

    Show(){
        [Console]::ForegroundColor = "DarkGray"
	    [Console]::Write($this.char)
    }
}

Class Wall{
    [char]$char = "#"

    Show(){
        [Console]::ForegroundColor = "Gray"
	    [Console]::Write($this.char)
    }
}

Class Exit{

    [char]$char = "D"
    
    Show(){
        [Console]::ForegroundColor = "Red"
	    [Console]::Write($this.char)
    }
}

Class Player{

    [char]$char = "@"
    [Hashtable]$pos = @{ x = 0; y = 0}

    Player([int]$x,[int]$y,[char]$char){
        $this.pos.x = $x
        $this.pos.y = $y
        $this.char = $char
    }

    Show(){
        [Console]::SetCursorPosition($this.pos.x, $this.pos.y)
        [Console]::ForegroundColor = "Cyan"
	    [Console]::Write($this.char)
    }

    MoveRight(){ $this.pos.x ++ }
    MoveLeft() { $this.pos.x -- }
    MoveDown() { $this.pos.y ++ }
    MoveUP()   { $this.pos.y -- }   
}

function LevelGenerator(){
    
    $L = [Level]::new(20,20)
    $L.map[5][0] = [Exit]::new()
    $step = 2

    for ($x = $step; $x -lt $L.map[$x].Count - $step; $x++) {
            for ($y = $step; $y -lt $L.map[$x].Count - $step; $y++) {

                $rnd = Get-Random -InputObject (0..10)
                if( $rnd -eq 0){
                    
                    $L.map[$x][$y] = [Exit]::new()
                }
            }
    }
    Return $L
}

function PlayerMovement($key){
    
    $PPX = $player.pos.x
    $PPY = $player.pos.y

    if ($key -eq "RightArrow"){ 
        if($level.map[$PPX +1][$PPY].char -eq "."){$player.MoveRight()}
    }
    if ($key -eq "LeftArrow"){ 
        if($level.map[$PPX -1][$PPY].char -eq "."){$player.MoveLeft()}
    }
    if ($key -eq "DownArrow"){ 
        if($level.map[$PPX][$PPY +1].char -eq "."){$player.MoveDown()}
    }
    if ($key -eq "UpArrow"){ 
        if($level.map[$PPX][$PPY -1].char -eq "."){$player.MoveUP()}
    }
}

$level = LevelGenerator
$player = [Player]::new(1,1, "@")

do{ # main loop
    [Console]::BackgroundColor = "DarkBlue"
    [Console]::Clear()
    [Console]::BackgroundColor = "Black"

    $level.Show()
    $player.Show()
    $input = [Console]::ReadKey(("NoEcho"))
    PlayerMovement($input.key)
}while ( $input.keychar -ne "q" )