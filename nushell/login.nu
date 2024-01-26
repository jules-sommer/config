
# echo "PATH @ login.nu : 1"
# echo $env.PATH

# echo "PATH LEN"
let $env_strs_len = ($env.PATH | str length)
let $env_count = ($env.PATH | length)

mut $sum = 0; for $x in $env_strs_len { $sum += $x }; if $sum >= 200 and $env_count >= 7 {
  print `SUM: {{ $sum }}`
	print "$env.PATH is set correctly!!"
}

if $env.NIX_PATH != null {
  # we are in Nix and that is scary for PATH :S
  
  } else {
  # Below is the default PATH for Ubuntu 20.04 and probs other distros, and we set it here
  # /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/sbin')
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/bin')
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/sbin')
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/bin')
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/sbin')
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/games')
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/bin')
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/snap/bin')
  $env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/games')
}