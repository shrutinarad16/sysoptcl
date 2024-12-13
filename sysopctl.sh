#!/bin/bash


VERSION="v0.1.0"

DARK_GREEN="\033[32m"  # Changed from RED to DARK_GREEN
BLUE="\033[34m"        # Changed from GREEN to BLUE
YELLOW="\033[33m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

function show_help {
    echo -e "${CYAN}${BOLD}Usage:${RESET} sysopctl [command] [options]"
    echo ""
    echo -e "${BOLD}Commands:${RESET}"
    echo -e "  ${BLUE}service list${RESET}           List all active services"
    echo -e "  ${BLUE}service start <name>${RESET}   Start a specific service"
    echo -e "  ${BLUE}service stop <name>${RESET}    Stop a specific service"
    echo -e "  ${BLUE}system load${RESET}            Show system load averages"
    echo -e "  ${BLUE}disk usage${RESET}             Show disk usage statistics"
    echo -e "  ${BLUE}process monitor${RESET}        Monitor real-time system processes"
    echo -e "  ${BLUE}logs analyze${RESET}           Analyze system logs"
    echo -e "  ${BLUE}backup <path>${RESET}          Backup system files to the specified path"
    echo ""
    echo -e "${BOLD}Options:${RESET}"
    echo -e "  ${YELLOW}--help${RESET}                 Show this help message"
    echo -e "  ${YELLOW}--version${RESET}              Show command version"
}

function show_version {
    echo -e "${CYAN}${BOLD}sysopctl version $VERSION${RESET}"
}

function list_services {
    echo -e "${YELLOW}${BOLD}Listing active services:${RESET}"
    systemctl list-units --type=service
}

function start_service {
    service_name="$1"
    if [ -z "$service_name" ]; then
        echo -e "${DARK_GREEN}${BOLD}Error:${RESET} Service name is required."
        exit 1
    fi
    systemctl start "$service_name" && echo -e "${BLUE}Service '$service_name' started.${RESET}"
}

function stop_service {
    service_name="$1"
    if [ -z "$service_name" ]; then
        echo -e "${DARK_GREEN}${BOLD}Error:${RESET} Service name is required."
        exit 1
    fi
    systemctl stop "$service_name" && echo -e "${BLUE}Service '$service_name' stopped.${RESET}"
}

function system_load {
    echo -e "${YELLOW}${BOLD}System Load Averages:${RESET}"
    uptime
}

function disk_usage {
    echo -e "${YELLOW}${BOLD}Disk Usage:${RESET}"
    df -h
}

function process_monitor {
    echo -e "${YELLOW}${BOLD}Monitoring Processes:${RESET}"
    top
}

function analyze_logs {
    echo -e "${YELLOW}${BOLD}Analyzing Logs:${RESET}"
    journalctl -p 3 -xb
}

function backup_files {
    backup_path="$1"
    if [ -z "$backup_path" ]; then
        echo -e "${DARK_GREEN}${BOLD}Error:${RESET} Backup path is required."
        exit 1
    fi
    rsync -av --progress / "$backup_path" && echo -e "${BLUE}Backup to '$backup_path' completed.${RESET}"
}


case "$1" in
    --help)
        show_help
        ;;
    --version)
        show_version
        ;;
    service)
        case "$2" in
            list)
                list_services
                ;;
            start)
                start_service "$3"
                ;;
            stop)
                stop_service "$3"
                ;;
            *)
                echo -e "${DARK_GREEN}Unknown service option. Use 'sysopctl --help' for usage.${RESET}"
                ;;
        esac
        ;;
    system)
        if [ "$2" == "load" ]; then
            system_load
        else
            echo -e "${DARK_GREEN}Unknown system option. Use 'sysopctl --help' for usage.${RESET}"
        fi
        ;;
    disk)
        if [ "$2" == "usage" ]; then
            disk_usage
        else
            echo -e "${DARK_GREEN}Unknown disk option. Use 'sysopctl --help' for usage.${RESET}"
        fi
        ;;
    process)
        if [ "$2" == "monitor" ]; then
            process_monitor
        else
            echo -e "${DARK_GREEN}Unknown process option. Use 'sysopctl --help' for usage.${RESET}"
        fi
        ;;
    logs)
        if [ "$2" == "analyze" ]; then
            analyze_logs
        else
            echo -e "${DARK_GREEN}Unknown logs option. Use 'sysopctl --help' for usage.${RESET}"
        fi
        ;;
    backup)
        backup_files "$2"
        ;;
    *)
        echo -e "${DARK_GREEN}Unknown command. Use 'sysopctl --help' for usage.${RESET}"
        ;;
esac
