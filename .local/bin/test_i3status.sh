#! /bin/bash 

#
# interpolates between two colours will be colour1 when value == minimum and colour2 when value == maximum 
#
# colours are 24-bit integers (6 hex digits, like HTML colour codes) 8 bits for each colour
fade()
{
	min=${5:-0}
	val=$(( $4 - $min ))
	echo $val | awk\
	-v r1=$(( $1 >> 16 ))\
	-v g1=$(( ($1 >> 8) & 0xff ))\
	-v b1=$(( $1 & 0xff ))\
	-v r2=$(( $2 >> 16 ))\
	-v g2=$(( ($2 >> 8) & 0xff ))\
	-v b2=$(( $2 & 0xff ))\
	-v max=$(( $3 - $min ))\
	'{ printf "%02x%02x%02x", r1+((r2-r1)*($1/max)), g1+((g2-g1)*($1/max)), b1+((b2-b1)*($1/max)); }'
}
# usage: fadevia <colour1> <colour2> <colour3> <maximum> <middle> <value> [minimum]
#
# interpolates between three colours will be colour1 when value == minimum, colour2 when value == middle and colour3 when value == maximum
#
# colours are 24-bit integers (6 hex digits, like HTML colour codes) 8 bits for each colour
fadevia()
{
	[ $6 -lt $5 ] && fade $1 $2 $5 $6 $7 || fade $2 $3 $4 $6 $5
}

label()
{
	printf '{"full_text":"%s","color":"#%06x","separator":false,"separator_block_width":4 },' "$2" "$1"
}

value()
{
	printf '{"full_text":"%s","color":"#%06x"},' "$2" "$1"
}


cpumem()
{
	cpumem=$(python3 -c 'from psutil import virtual_memory, cpu_percent; print("%f,%f" % (cpu_percent(0.3),virtual_memory().percent))')
	cpu=${cpumem%,*}
	mem=${cpumem#*,}
	label 0x999999 MEM
	value 0x$(fadevia 0xafd787 0xdf5f00 0xff005f 100 50 ${mem%\.*}) "$(printf '%5.1f%%' ${mem})"

	label 0x999999 CPU
	value 0x$(fadevia 0xafd787 0xdf5f00 0xff005f 100 50 ${cpu%\.*}) "$(printf '%5.1f%%' ${cpu})"
}

mpdstat()
{
	if [ -f ~/.config/mpd/pid ]; then
		eval $(mpc | awk 'NR == 1 {printf "current=\"%s\" ",$0}
				  NR == 2 {printf "state=\"%s\" time=\"%s\" perc=\"%s\" ",$1,$3,$4}
				  NR == 3 {if ($1 == "volume:") printf "vol=\"%s\" ",$2; else {split($1, vol, ":"); printf "vol=\"%s\" ",vol[2] } }')
		[[ "$state" == "[playing]" ]] && col=0x639b6f || col=0xff005f
		label "${col}" "${current}"
		value 0xaaaaaa "$(printf '%5s/%5s' ${time%/*} ${time#*/})"
	
		vol=${vol//%/}
	
		label 0x999999 VOL
		value 0x$(fadevia 0xafd787 0xdf5f00 0xff005f 100 50 $vol) "$(printf '%3d%%' ${vol})"
	fi
}

fs()
{
	perc=$(df $1 | awk -vfs=$1 '$NF == fs {printf "%d", $5}')
	label 0x999999 "$1"
	value 0x$(fadevia 0xafd787 0xdf5f00 0xff005f 100 50 ${perc}) "$(printf '%3d%%' ${perc})"
}

datetime()
{
	label 0x999999 "CLOCK"
	value 0xcccccc "$(date '+%F %H:%M')"
}

echo "{\"version\":1}"
echo "[[] ,"

while true
do
time cat <<EOF
[$(mpdstat)
$(fs /home)
$(fs /)
$(cpumem)
$(datetime)
EOF
sleep 0.5
done

