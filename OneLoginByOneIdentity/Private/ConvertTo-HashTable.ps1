Function ConvertTo-HashTable {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [PSCustomObject]
        $CustomObject
    )

    <# Rich Lambert said I needed more comments in my code so here is a comment for him
        This function is weird. It just converts a PSCustomObject to a hashtable
        because Powershell does weird things with classes sometimes
        and this may be dumb, but it was the easiest way I saw to get certain weird things
        to work the way I needed them to when I was deep in the weeds.

        Happy, Rich?
    #>

    $Hashtable = @{}

    ForEach ($Property in $CustomObject.psobject.properties) {
        $Hashtable[$Property.Name] = $Property.Value
    }

    Return $HashTable

}