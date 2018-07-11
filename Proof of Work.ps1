$sha1 = [System.Security.Cryptography.SHA1CryptoServiceProvider]::Create()

# initialise the nonce
$i = 0
$i.ToString("X08")
# proof-of-work loop
while ($i -lt [Int]::MaxValue)
{
    $input = "2017:04:07 to Alan Kelly:{0}" -f $i.ToString("X08")
    $hash = $sha1.ComputeHash([System.Text.UTF8Encoding]::UTF8.GetBytes($input))

    # the proof of work is to have a has that has three consecutive bytes [0x0, 0x1, 0x2]
    if ($hash[0] -eq 0 -and $hash[1] -eq 1 -and $hash[2] -eq 2)
    {
        # output the successful nonce and end the loop
        "Success with $i"
        $i = [Int]::MaxValue
    }

    $i++
}
