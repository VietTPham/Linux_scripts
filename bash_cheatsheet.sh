#progress bar %
echo -ne $(bc -l <<< "($start/$stop) * 100" | sed 's/\..*//')%\\r
