#!/usr/bin/env fish

function pullgroup -d "Pull and update all repositories in a group"
    if test -z "$argv[1]"
        echo "Usage: pullgroup [group]"
        return 1
    end

    set group $argv[1]
    set result (glab repo ls -a -g $group | string trim | string match -r '.+')
    set pages (seq 1 (echo $result[1] | awk '{ split($9, a, ")"); print a[1] }'))

    for i in (seq (count $pages))
        if test (count $result) -lt 2
            echo -e "\033[31;1mNo repositories found\033[0m"
            return 0
        end

        set page $pages[$i]
        echo -e "\033[32;1mProcessing page $page\033[0m"

        set repos (printf "%s\n" $result[2..-1] | awk '{ print $1, $2 }')
        for repo in $repos
            set repo_data (string split ' ' $repo)
            set repo_name (echo $repo_data[1] | awk -F'/' '{ print $NF }')

            if test -z (string match -r 'git@' "$repo_data[2]")
                echo -e "\033[31;1mSkipping $repo_name as it is not a git repository\033[0m"
                continue
            end

            echo -e "\033[32;1mPulling $repo_name from $repo_data[2]\033[0m"
            if test -d "$repo_name"
                cd $repo_name
                git checkout master
                git pull
                cd ..
            else
                echo -e "\033[36;1mRepository $repo_name does not exist. Cloning...\033[0m"
                git clone $repo_data[2]
            end
        end

        if test $page -lt $pages[-1]
            set next (math $i + 1)
            set result (glab repo ls -a -g $group -p $pages[$next] | string trim | string match -r '.+')
        end
    end
end
