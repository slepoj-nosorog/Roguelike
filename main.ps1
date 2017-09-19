if ($(Get-Host).Name.Contains("ISE")){

    start-process PowerShell.exe -argument $MyInvocation.MyCommand.Definition
    Return

}

[Hashtable]$DisplaySize = @{ width = 70; height = 50}

[Console]::CursorVisible = $false
[Console]::Title = "!!"
[Console]::BufferWidth = $DisplaySize.width
[Console]::BufferHeight = $DisplaySize.height
[Console]::WindowWidth = $DisplaySize.width
[Console]::WindowHeight = $DisplaySize.height

Class Level{
    
    [System.Array]$map
    [Hashtable]$size = @{ width = 0; height = 0}

    # Class constructor
    Level ([int]$width, [int]$height, [char]$char){

        $this.size.width = $width
        $this.size.height = $height

        $this.map = New-Object "object[,]" $this.size.width,$this.size.height

        for ($x = 0; $x -lt $this.size.width; $x++) {
            for ($y = 0; $y -lt $this.size.height; $y++) {
                $this.map[$x,$y] = $char
            }
        }
    }

    #method
    Show(){
        for ($x = 0; $x -lt $this.size.width; $x++) {
            for ($y = 0; $y -lt $this.size.height; $y++) {
                
                [Console]::SetCursorPosition($x, $y)
                [Console]::Write( ($this.map[$x,$y]) )

            }
        }
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
	    [Console]::Write($this.char)

    }

    Move([string]$key){
        
        if ($key -eq "RightArrow"){ $this.pos.x ++ }
        if ($key -eq "LeftArrow") { $this.pos.x -- }
        if ($key -eq "DownArrow") { $this.pos.y ++ }
        if ($key -eq "UpArrow")   { $this.pos.y -- }

    }
}





$level = [Level]::new(20,20,'.')
$player = [Player]::new(3,3, "@") 

# main loop
do
{
	[Console]::Clear()

    $level.Show()
    $player.Show()

	$input = [Console]::ReadKey(("NoEcho"))

    $player.Move( $input.key )

} while ($input.keychar -ne "q")