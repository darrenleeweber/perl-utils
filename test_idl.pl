
@voltage = (-10..10);
$step = 1.0;

# Obtain max/min range of voltage values
$max = max(@voltage);
$min = min(@voltage);

# Define number of positive/negative levels, given step and range
$plevels = fix (ceil ($max / $step));
$nlevels = fix (ceil (abs ($min / $step) ));

if ($min < 0.0){

	$Vn[0] = 0;
	foreach $a (1..(nlevels - 1)){ 
		$Vn[a] = -1 * ($step * $a);
	}
	@VLevels = reverse(@Vn);
}

if ($max > 0.0){

	$Vp[0] = 0;
	foreach $a (1..(plevels - 1)){ 
		$Vp[a] = $step * $a;
	}
	push(@VLevels, @Vp);
}
