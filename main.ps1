if ($(Get-Host).Name.Contains("ISE")){

    start-process PowerShell.exe -argument $MyInvocation.MyCommand.Definition
    Return

}

Function writetext($x, $y , $symbol){
	
	[Console]::SetCursorPosition($x, $y)
	[Console]::Write($symbol)
    [Console]::CursorVisible = $false

}

Class Level{
    
    [System.Array]$map

    # Class constructor
    Level ([int]$width, [int]$height, [char]$char){

        $this.map = New-Object "object[,]" $width,$height

        for ($x = 0; $x -lt $width; $x++) {
            for ($y = 0; $y -lt $height; $y++) {
                $this.map[$x,$y] = $char
            }
        }
    }

    #method
    [char]Write([int]$x,[int]$y){
        Return $this.map[$x,$y]
    }
}

$width = 20
$height = 20

$map = [Level]::new($width,$height,'`')

function newPlayer()
{
	$player = New-Object PSObject
	$player | Add-Member -type Noteproperty -Name x -Value 3
	$player | Add-Member -type Noteproperty -Name y -Value 3
	$player | Add-Member -type Noteproperty -Name char -Value "@"

	return $player
}

#create the player object
$player = newPlayer

# main loop
do
{
	[Console]::Clear()
	for($i=1; $i -le $width-1; $i++)
	{
		for($j=1; $j -le $height-1; $j++)
		{
			writetext $i $j $map.Write($i,$j)
		}
	}
	writetext $player.x $player.y $player.char

	$input = [Console]::ReadKey(("NoEcho"))
	if ($input.key -eq "RightArrow"){ $player.x = $player.x + 1 }
	if ($input.key -eq "LeftArrow"){ $player.x = $player.x - 1 }
	if ($input.key -eq "DownArrow"){ $player.y = $player.y + 1 }
	if ($input.key -eq "UpArrow"){ $player.y = $player.y - 1 }
} while ($input.keychar -ne "q")

