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

[Hashtable]$DisplaySize = @{ width = 70; height = 25}
[Console]::CursorVisible = $false
[Console]::Title = "!Roguelike Zombie!"
[Console]::BufferWidth = $DisplaySize.width
[Console]::BufferHeight = $DisplaySize.height
[Console]::WindowWidth = $DisplaySize.width
[Console]::WindowHeight = $DisplaySize.height + 20
$levelWidth = $DisplaySize.width / 2
$levelHeight = $DisplaySize.height

Class Level{
    
    <#
        На данный момент клас это матрица.
        Если каджый обьект хранит свое место расположение то 
        класс Level Это просто место хранение всех обьектов на уровне
        Список.

        Возможно стоит переписать его под список.
        Или ваывести в переменную для сохранения герератора уровней
    #>

    [System.Array]$map

    Level([int]$width, [int]$height){
        $this.map = New-Object "object[][]" $width,$height
        for ($x = 0; $x -lt $this.map.Count; $x++) {
            for ($y = 0; $y -lt $this.map[$x].Count; $y++) {

                $this.map[$x][$y] = [Ground]::new($x,$y)

                if( $x -eq 0 -or $y -eq 0 ){ 
                    $this.map[$x][$y] = [Wall]::new($x,$y)
                }
                if( $x -eq $this.map.Count -1 -or $y -eq $this.map[$x].Count -1 ){ 
                    $this.map[$x][$y] = [Wall]::new($x,$y)
                }
            }
        }
    }

    Show(){
        for ($x = 0; $x -lt $this.map.Count ; $x++) {
            for ($y = 0; $y -lt $this.map[$x].Count; $y++) {
                $object = $this.map[$x][$y]
                $object.Show()
            }
        }
    }
}

Class Ground{

    [char]$char = "."
    [int]$x
    [int]$y
    [bool]$solid = $false

    Ground($x, $y){
        $this.x = $x
        $this.y = $y
    }

    Show(){
        [Console]::SetCursorPosition($this.x, $this.y)
        [Console]::ForegroundColor = "DarkGray"
	    [Console]::Write($this.char)
    }
}

Class Wall{

    [char]$char = "#"
    [int]$x
    [int]$y
    [bool]$solid = $true

    Wall($x, $y){
        $this.x = $x
        $this.y = $y
    }

    Show(){
        [Console]::SetCursorPosition($this.x, $this.y)
        [Console]::ForegroundColor = "Gray"
	    [Console]::Write($this.char)
    }
}

Class Out{

    [char]$char = "D"
    [int]$x
    [int]$y
    [bool]$solid = $false

    Out($x, $y){
        $this.x = $x
        $this.y = $y
    }

    Show(){
        [Console]::SetCursorPosition($this.x, $this.y)
        [Console]::ForegroundColor = "Red"
	    [Console]::Write($this.char)
    }
}

Class Player{

    [char]$char = "@"
    [int]$x
    [int]$y
    [bool]$solid = $false

    Player([int]$x,[int]$y){
        $this.x = $x
        $this.y = $y
    }

    Show(){
        [Console]::SetCursorPosition($this.x, $this.y)
        [Console]::ForegroundColor = "Cyan"
	    [Console]::Write($this.char)
    }

    MoveRight(){ $this.x ++ }
    MoveLeft() { $this.x -- }
    MoveDown() { $this.y ++ }
    MoveUP()   { $this.y -- }   
}

function LevelGenerator(){
    
    $L = [Level]::new($levelWidth, $levelHeight)
    #$L.map[5][0] = [Out]::new(5,0)
    $step = 2

    for ($x = $step; $x -lt $L.map[$x].Count - $step; $x++) {
        for ($y = $step; $y -lt $L.map[$x].Count - $step; $y++) {
            <#
                Написать внятный рандом
            #>
            if((Get-Random $levelWidth) -eq (Get-Random $levelWidth)){
                $L.map[$x][$y] = [Out]::new($x,$y)
            }
        }
    }
    Return $L
}

function PlayerMovement($key){
    
    $PPX = $player.x
    $PPY = $player.y

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
$player = [Player]::new(1,1)

do{ # main loop
    [Console]::BackgroundColor = "DarkBlue"
    [Console]::Clear()
    [Console]::BackgroundColor = "Black"

    $level.Show()
    $player.Show()
    $input = [Console]::ReadKey(("NoEcho"))
    PlayerMovement($input.key)
}while ( $input.keychar -ne "q" )