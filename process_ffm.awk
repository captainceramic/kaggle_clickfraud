#!/usr/bin/awk -f

BEGIN {
    FS=",";
    OFS=" ";
    global_count = 1;
}

NR==1 {
    /* Build an array of column names */
    for(i=1; i<=NF; i++) {
	column_names[i] = $i;
    }
}
NR>1 {
    /* First we need to check if the combination of column and value exists in the value array. */
    newline = "";
    for(i=1; i<=NF; i++) {

	/* Ignore the attributed time */
	if (column_names[i] == "click_time") {
	    gsub(/:/, " ", $i);
	    gsub(/-/, " ", $i);
	    newline = newline " " i ":1:" mktime($i);
	    continue;
	}

	if (column_names[i] == "attributed_time") {
	    continue;
	}

	if (column_names[i] == "is_attributed") {
	    newline = $i newline;
	    continue;
	}
	
	thisval = column_names[i] $i;
	if (!(thisval in all_values)) {
	    all_values[thisval] = global_count;
	    global_count++;
	}
	
	newline = newline " " i ":" all_values[thisval] ":1";
    }

    print newline;
    
}
