function catFacts {
    Param(
        [string]$open="It is now time for a cat fact....",
        [string]$fact=(((Invoke-WebRequest -Uri https://catfact.ninja/fact -UseBasicParsing).content | ConvertFrom-Json).fact),
        [int]$rate = 2
        )

    $speak = "$open $fact"
    $v=New-Object -com SAPI.SpVoice
    $voice = $v.getvoices() | Where {$_.id -like "*ZIRA*"}
    $v.voice= $voice
    $v.rate=$rate
    $v.speak($speak)
}
catFacts