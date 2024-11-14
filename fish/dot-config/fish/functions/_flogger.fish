set -g __flogger_levels   "DEBUG"  "INFO"   "WARN"   "ERROR"  "FATAL" "CRITICAL"
set -g __flogger_color_fg "green"  "blue"   "yellow" "red"    "white" "yellow"
set -g __flogger_color_bg ""       ""       ""       ""       "red"   "red"

function _flogger --description "Logger helper for fish shell"
  argparse --stop-nonopt --ignore-unknown --name=_flogger 'n/name=' 't/timestamp' 'l/level=!__flogger_validate_level "$_flag_value"' -- $argv
  or return

  set -l message_level (string upper $_flag_level)
  set -l runtime_level (string upper $LOGLEVEL)

  if test -z "$message_level"
    set message_level "INFO"
  end
  if test -z "$runtime_level" || ! __flogger_validate_level $runtime_level &> /dev/null
    set runtime_level "INFO"
  end

  if ! __flogger_should_log $message_level $runtime_level
    return
  end

  set -l level_index (contains --index $message_level $__flogger_levels)
  set -l level_color_fg $__flogger_color_fg[$level_index]
  set -l level_color_bg $__flogger_color_bg[$level_index]

  if test -n "$_flag_name"
    __flogger_cprintf -o -c $level_color_fg -b $level_color_bg "[$_flag_name] "
  end
  if test -n "$_flag_timestamp"
    __flogger_cprintf -o -c $level_color_fg -b $level_color_bg "$(date --iso-8601=seconds) "
  end
  __flogger_cprintf -o -c $level_color_fg -b $level_color_bg "$message_level: "
  __flogger_cprintf -C -c $level_color_fg -b $level_color_bg "$argv"
  __flogger_cprintf -C '\n'
end

function __flogger_should_log -a message_level runtime_level
  set -l message_level_index (contains --index $message_level $__flogger_levels)
  set -l runtime_level_index (contains --index $runtime_level $__flogger_levels)
  test $message_level_index -ge $runtime_level_index
end

function __flogger_validate_level
  set -l level $argv[1]
  if test -z "$level"
    __flogger_cprintf -o -c red "[_flogger] ERROR: missing log level"
    return 1
  end
  if ! contains (string upper $level) $__flogger_levels
    __flogger_cprintf -o -c red "[_flogger] ERROR: invalid log level: "
    __flogger_cprintf -u "'$level'"
    __flogger_cprintf -o -c red -C ", allowed levels: $__flogger_levels\n"
    return 1
  end
  return 0
end

function __flogger_cprintf
  argparse 'c/color=' 'b/bg=' 'o/bold' 'd/dim' 'i/italics' 'r/reverse' 'u/underline' 'C/clear' -- $argv
  or return

  if test -n "$_flag_clear"
    set_color normal
  end

  set -l color_args
  if test -n "$_flag_bg"
    set -a color_args "--background" "$_flag_bg"
  end

  if test -n "$_flag_bold"
    set -a color_args "--bold"
  end

  if test -n "$_flag_dim"
    set -a color_args "--dim"
  end

  if test -n "$_flag_italics"
    set -a color_args "--italics"
  end

  if test -n "$_flag_reverse"
    set -a color_args "--reverse"
  end

  if test -n "$_flag_underline"
    set -a color_args "--underline"
  end

  if test -n "$_flag_color"
    set -a color_args "$_flag_color"
  end

  set_color $color_args
  if test -n "$argv"
    printf $argv >&2
  end
end
