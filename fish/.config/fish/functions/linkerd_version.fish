#!/usr/bin/env fish

function linkerd_version -d "setup correct linkerd version"
    set RED (set_color red)
    set YELLOW (set_color yellow)
    set GREEN (set_color green)
    set NC (set_color normal) # no color

    k get ns linkerd >/dev/null
    if test $status -ne 0
        echo -e "$YELLOW"linkerd is not available in this cluster"$NC"
        return 1
    end

    set output (k get deployment linkerd-identity -n linkerd -o json | jq -r '.metadata.labels."app.kubernetes.io/version"' | sed 's/-/ /')
    if test $status -ne 0
        echo -e "$RED"Error: Please make sure you are authenticated to gcloud"$NC"
        return 1
    end

    set linkerd_binary_edition (echo $output | cut -d' ' -f1)
    set linkerd_binary_version (echo $output | cut -d' ' -f2)

    # Check system architecture
    switch (uname -m)
        case arm64
            set ARCH arm64
        case x86_64
            set ARCH amd64
        case '*'
            echo -e "$RED"Error: Unsupported architecture"$NC"
            return 1
    end

    # Check if linkerd binary version is installed
    grep -qI . $HOME/bin/linkerd-$linkerd_binary_version
    set gstat $status
    if test -f $HOME/bin/linkerd-$linkerd_binary_version; and test $gstat -ne 0
        echo -e "linkerd version: $GREEN$linkerd_binary_version$NC"

        # Symlink linkerd binary to $HOME/bin
        ln -sf $HOME/bin/linkerd-$linkerd_binary_version $HOME/bin/linkerd
    else
        echo -e "$RED"linkerd binary version $linkerd_binary_version is not installed or not in "$HOME"/bin, installing it"$NC"

        # Determine the CLI URL based on the edition and architecture
        set cli_url ""
        if test "$linkerd_binary_edition" = enterprise
            set cli_url "https://github.com/buoyantio/linkerd-buoyant/releases/download/enterprise-$linkerd_binary_version/linkerd-enterprise-$linkerd_binary_version-darwin-$ARCH"
        else if test "$linkerd_binary_edition" = stable
            set arch_suf ""
            if test $ARCH = arm64
                set arch_suf -arm64
            end
            set cli_url "https://github.com/linkerd/linkerd2/releases/download/stable-$linkerd_binary_version/linkerd2-cli-stable-$linkerd_binary_version-darwin$arch_suf"
        end

        # Download the CLI
        curl -Lso $HOME/bin/linkerd-$linkerd_binary_version $cli_url

        # Verify the installation of the CLI
        grep -qI . $HOME/bin/linkerd-$linkerd_binary_version
        set gstat $status
        if test -f $HOME/bin/linkerd-$linkerd_binary_version; and test $gstat -ne 0
            chmod +x $HOME/bin/linkerd-$linkerd_binary_version
            echo -e "linkerd version: $GREEN$linkerd_binary_version$NC"

            # Symlink linkerd binary to $HOME/bin
            ln -sf $HOME/bin/linkerd-$linkerd_binary_version $HOME/bin/linkerd
        else
            echo -e "$RED"linkerd binary version $linkerd_binary_version not installed or not in "$HOME"/bin. Please install it manually"$NC"
            echo -e "Download URL was: $cli_url"

            if not test -O $HOME/bin -a -G $HOME/bin
                echo -e "$RED"Please run chown -R (whoami):(id -gn) \$HOME/bin"$NC"
            end
        end
    end
end
