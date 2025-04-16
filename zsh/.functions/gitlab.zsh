#!/bin/bash

pullgroup() {
    if [[ -z "$1" ]]; then
        echo "Usage: pullgroup [group]"
        return 1
    fi

    local group="$1"
    local result pages repos repo_data repo_name page

    IFS=$'\n'
    result=($(glab repo ls -a -g "$group" | sed '/^$/d'))
    unset IFS

    pages=($(seq 1 $(echo "${result[0]}" | awk '{ split($9, a, ")"); print a[1] }')))

    for i in {1..${#pages[@]}}; do
        if [[ ${#result[@]} -lt 2 ]]; then
            echo -e "\033[31;1mNo repositories found\033[0m"
            return 0
        fi

        page=${pages[$i]}
        echo -e "\033[32;1mProcessing page $page\033[0m"

        repos=$(printf "%s\n" "${result[@]:1}" | awk '{ print $1, $2 }')
        while read -r name url; do
            repo_name=$(basename "$name")

            if ! [[ "$url" =~ git@ ]]; then
                echo -e "\033[31;1mSkipping $repo_name as it is not a git repository\033[0m"
                continue
            fi

            echo -e "\033[32;1mPulling $repo_name from $url\033[0m"
            if [[ -d "$repo_name" ]]; then
                cd "$repo_name" || continue
                git checkout master
                git pull
                cd ..
            else
                echo -e "\033[36;1mRepository $repo_name does not exist. Cloning...\033[0m"
                git clone "$url"
            fi
        done <<< "$repos"

        if (( page < pages[-1] )); then
            next=$((i + 1))
            result=($(glab repo ls -a -g "$group" -p "${pages[$next]}" | sed '/^$/d'))
        fi
    done
}
