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

    /* If we don't have an 'is_attributed' column then add a dummy zero first. */
    if (!("is_attributed" in column_names)) {
	add_dummy_zero = 0;
    } else {
	add_dummy_zero = 1;
    }
}

NR>1 {

    if (add_dummy_zero) {
	newline = "0 ";
    } else {
	newline = "";
    }

    for(i=1; i<=NF; i++) {

	if (column_names[i] == "click_time") {
	    gsub(/:/, " ", $i);
	    gsub(/-/, " ", $i);
	    split($i, time_components, " ");
	    k = 0;
	    for (l in time_components) {
		thisval = "timecomponent" k "_" time_components[l];
		if (!(thisval in all_values)) {
		    all_values[thisval] = global_count;
		    global_count++;
		}
		newline = newline " " i+k ":" all_values[thisval] ":1";
		k++;
				
	    }
	    continue;
	}

	/* Ignore the attributed time */
	if (column_names[i] == "attributed_time") {
	    continue;
	}

	if (column_names[i] == "is_attributed") {
	    newline = $i newline;
	    continue;
	}
	
	thisval = column_names[i] "_" $i;
	if (!(thisval in all_values)) {
	    all_values[thisval] = global_count;
	    global_count++;
	}
	
	newline = newline " " i ":" all_values[thisval] ":1";
    }

    print newline;
    
}

END {
    /* Save out the values array */
    for (value in all_values) {
	print value, all_values[value] > "values_array.data";
    }
    
}
