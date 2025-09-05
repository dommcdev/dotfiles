#!/usr/bin/env bash
file="../todo.txt"

git log --follow --format="%h %ad" --date=short -- "$file" | while read -r hash date; do
    count=$(git show "$hash:$file" 2>/dev/null | grep -cve '^\s*$')
    echo "$date $count"
done | sort > line_history.dat

# Plot with gnuplot
gnuplot -persist <<EOF
set title "Non-blank lines in $file over time"
set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"
set xlabel "Date"
set ylabel "Line count"
set grid
plot "line_history.dat" using 1:2 with linespoints title "Lines"
EOF
