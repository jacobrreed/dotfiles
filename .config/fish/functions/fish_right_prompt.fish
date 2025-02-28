function fish_right_prompt
    set -l SEC 1000
    set -l MIN 60000
    set -l HOUR 3600000
    set -l DAY 86400000

    set -l num_days (math -s0 "$CMD_DURATION / $DAY")
    set -l num_hours (math -s0 "$CMD_DURATION % $DAY / $HOUR")
    set -l num_mins (math -s0 "$CMD_DURATION % $HOUR / $MIN")
    set -l num_secs (math -s0 "$CMD_DURATION % $MIN / $SEC")
    set -l num_millis (math -s0 "$CMD_DURATION % $SEC")
    set -l cmd_duration_str ""
    if [ $num_days -gt 0 ]
        set cmd_duration_str {$cmd_duration_str}{$num_days}"d "
    end
    if [ $num_hours -gt 0 ]
        set cmd_duration_str {$cmd_duration_str}{$num_hours}"h "
    end
    if [ $num_mins -gt 0 ]
        set cmd_duration_str {$cmd_duration_str}{$num_mins}"m "
    end
    if [ $num_secs -gt 0 ]
        set -l num_millis_pretty ''
        if begin
                set -q fish_command_timer_millis; and [ "$fish_command_timer_millis" -ne 0 ]
            end
            set num_millis_pretty (printf '%03d' $num_millis)
        end
        set cmd_duration_str {$cmd_duration_str}{$num_secs}s{$num_millis_pretty}
        echo $cmd_duration_str
    end
end
