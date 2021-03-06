Function ConvertTo-MaskLength {
    [CmdLetBinding()]
    Param(
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
        [Alias("Mask")]
        [Net.IPAddress]$SubnetMask
    )

    Process {

        function IsValidMaskBits ($Bits) {
            $Bits = [convert]::ToString($Bits, 2).PadLeft(8, '0')
            $Bits = $Bits.ToCharArray()
            $ZeroFound = $false
            foreach ($b in $Bits) {
                switch ($b) {
                    0 {
                        $ZeroFound = $true
                        continue
                    }
                    1 {
                        if ($ZeroFound) {
                            return $false
                        } else {
                            continue
                        }
                    }
                }
            }
            return $true
        }

        foreach ($byte in $SubnetMask.GetAddressBytes()) {
            $IsValid = IsValidMaskBits $b
        }

        if ($IsValid) {
            $MaskLength = ""
            foreach ($byte in $SubnetMask.GetAddressBytes()) {
                if (($null -eq $lastbyte) -or ($byte -le $lastbyte)) {
                    $MaskLength += [Convert]::ToString($byte, 2) -replace '0'
                    $lastbyte = $byte
                } else {
                    Throw "Not a valid Subnet Mask"
                }
            }
        } else {
            Throw "Not a valid Subnet Mask"
        }
        Return $MaskLength.Length
    }
}