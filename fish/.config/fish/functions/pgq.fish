#!/usr/bin/env fish

function print_usage
    echo -e "\e[$argv[1]mUsage: pgq [user] [query]\e[0m"
    echo -e "\e[$argv[1]mOptions:\e[0m"
    echo -e "\e[$argv[1]m  -h, --help   Display command help\e[0m"
    echo -e "\e[$argv[1]m  -n, --name   Database name; defaults to DEV_PG_DB_NAME\e[0m"
    echo -e "\e[$argv[1]m  -p, --pod    Pod name; defaults to DEV_PG_DB_POD\e[0m"
    echo -e "\e[$argv[1]m  -x, --expand Expanded display\e[0m"
end

function pgq -d "Run a psql command on a k8s pod"
    argparse h/help n/name p/pod x/expand -- $argv
    or return

    if set -q _flag_help
        print_usage 32
        return 0
    else if test (count $argv) -lt 2
        print_usage 31
        return 1
    end

    set pod $DEV_PG_DB_POD
    if set -q _flag_pod
        set pod $_flag_pod
    end

    set db $DEV_PG_DB_NAME
    if set -q _flag_name
        set db $_flag_name
    end

    set user $argv[1]
    set query $argv[2]

    if set -q _flag_expand
        kpgq -x $pod $db $user $query
    else
        kpgq $pod $db $user $query
    end
end
