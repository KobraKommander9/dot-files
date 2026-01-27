# requires kubectl jq

linkerd_version() {
    local RED=$'\e[31m'
    local YELLOW=$'\e[33m'
    local GREEN=$'\e[32m'
    local NC=$'\e[0m'

    if ! kubectl get ns linkerd >/dev/null 2>&1; then
        echo -e "${YELLOW}linkerd is not available in this cluster${NC}"
        return 1
    fi

    local raw_output
    raw_output=$(kubectl get deployment linkerd-identity -n linkerd -o jsonpath='{.metadata.labels.app\.kubernetes\.io/version}' 2>/dev/null | tr -d '[:space:]')

    if [[ -z "$raw_output" ]]; then
        echo -e "${RED}Error: Could not find linkerd version label.${NC}"
        return 1
    fi

    local edition="${raw_output%%-*}"
    local version="${raw_output#*-}"

    local arch
    case "$(uname -m)" in
        arm64)  arch="arm64" ;;
        x86_64) arch="amd64" ;;
        *) echo -e "${RED}Unsupported architecture${NC}"; return 1 ;;
    esac

    local target_dir="$HOME/bin"
    local bin_path="$target_dir/linkerd-$raw_output"
    local symlink_path="$target_dir/linkerd"

    [[ ! -d "$target_dir" ]] && mkdir -p "$target_dir"

    if [[ -f "$bin_path" ]] && [[ -s "$bin_path" ]]; then
        echo -e "linkerd version: ${GREEN}${version}${NC}"
        ln -sf "$bin_path" "$symlink_path"
    else
        echo -e "${YELLOW}Version $version not found locally. Downloading...${NC}"

        local cli_url=""
        if [[ "$edition" == "enterprise" ]]; then
            cli_url="https://github.com/buoyantio/linkerd-buoyant/releases/download/enterprise-$version/linkerd-enterprise-$version-darwin-$arch"
        else
            local arch_suf=""
            [[ "$arch" == "arm64" ]] && arch_suf="-arm64"
            cli_url="https://github.com/linkerd/linkerd2/releases/download/stable-$version/linkerd2-cli-stable-$version-darwin$arch_suf"
        fi

        if curl -fLso "$bin_path" "$cli_url"; then
            chmod +x "$bin_path"
            ln -sf "$bin_path" "$symlink_path"
            echo -e "Successfully installed linkerd ${GREEN}$version${NC}"
        else
            echo -e "${RED}Download failed! Check your connection or URL.${NC}"
            echo -e "URL: $cli_url"
            [[ -f "$bin_path" ]] && rm "$bin_path"
            return 1
        fi
    fi
}
