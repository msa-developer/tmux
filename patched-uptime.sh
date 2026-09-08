#!/usr/bin/env bash
# =============================================================================
# Plugin: uptime
# Description: Display system uptime (exact `uptime -p` output)
# Contract-based plugin (PowerKit)
# =============================================================================

POWERKIT_ROOT="${POWERKIT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
. "${POWERKIT_ROOT}/src/contract/plugin_contract.sh"


plugin_get_metadata() {
    metadata_set "id" "uptime"
    metadata_set "name" "Uptime"
    metadata_set "description" "Display system uptime"
}

plugin_declare_options() {
    declare_option "icon" "icon" $'\uf254' "Plugin icon"

    # Cache - overridden in .tmux.conf for real-time updates
    declare_option "cache_ttl" "number" "5" "Cache duration in seconds"
}


plugin_get_content_type() { printf 'dynamic'; }
plugin_get_presence() { printf 'always'; }
plugin_get_state() { printf 'active'; }
plugin_get_health() { printf 'ok'; }

plugin_get_context() {
    local uptime_str=$(plugin_data_get "uptime")
    # uptime -p => "up 1 hour, 5 minutes" / "up 2 days, 3 hours" / "up 47 minutes"
    if [[ "$uptime_str" == *day* ]]; then
        printf 'days'
    elif [[ "$uptime_str" == *hour* ]]; then
        printf 'hours'
    else
        printf 'minutes'
    fi
}

plugin_collect() {
    local up_str
    up_str=$(uptime -p 2>/dev/null)
    if [[ -n "$up_str" ]]; then
        plugin_data_set "uptime" "$up_str"
    else
        # Fallback: compute from /proc/uptime
        local uptime_seconds=0
        if is_linux && [[ -r /proc/uptime ]]; then
            uptime_seconds=$(awk '{printf "%d", $1}' /proc/uptime 2>/dev/null)
        elif is_macos; then
            local boot_time now=$EPOCHSECONDS
            boot_time=$(sysctl -n kern.boottime | awk '{gsub(",", "", $4); print $4}')
            ((uptime_seconds=now-boot_time))
        fi
        plugin_data_set "uptime" "$(format_uptime_seconds "$uptime_seconds")"
    fi
}

plugin_render() {
    plugin_data_get "uptime"
}

plugin_get_icon() {
    get_option "icon"
}
