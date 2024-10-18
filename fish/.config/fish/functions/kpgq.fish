#!/usr/bin/env fish

function print_usage
      echo -e "\e[$argv[1]mUsage: kpgq [pod name] [database name] [user name] [query]\e[0m"
      echo -e "\e[$argv[1]mOptions:\e[0m"
      echo -e "\e[$argv[1]m  -h, --help   Display command help\e[0m"
      echo -e "\e[$argv[1]m  -x, --expand Expanded display\e[0m"
end

function kpgq -d "exec into pod and execute a query via psql"
    argparse 'h/help' 'x/expand' -- $argv
    or return

    if set -q _flag_help
      print_usage 32
      return 0
    else if test (count $argv) -lt 4
      echo -e $argv
      print_usage 31
      return 1
    end

    if set -q _flag_expand
      kubectl exec $argv[1] -- psql -h $argv[2] -U $argv[3] -c '\x' -c "$argv[4]"
    else
      kubectl exec $argv[1] -- psql -h $argv[2] -U $argv[3] -c "$argv[4]"
    end
end
