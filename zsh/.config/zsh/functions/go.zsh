# requires: go

alias gog="go generate"

gocover() {
  local clean=false
  local open_report=false
  local generate_tests=false
  local timeout=""
  local dir="./..."
  local ignore='(/*ctl/|/testdata/|/mock/|/generate.go|\.cp\.go|\.pb\.go|\.mg\.go|\.mock\.go)'

  OPTIND=1
  while getopts "gcot:h" opt; do
    case "$opt" in
      g) generate_tests=true ;;
      c) clean=true ;;
      o) open_report=true ;;
      t) timeout=$OPTARG ;;
      h|*)
        echo "Usage: gocover [-g] [-c] [-o] [-t] [path]"
        echo "  -g  generate dummy _test.go files for coverage"
        echo "  -c  clean up cover/ directory and exit"
        echo "  -o  open HTML report in browser"
        echo "  -t  set go test timeout (e.g. 30s)"
        return 0
        ;;
    esac
  done
  shift $((OPTIND-1))

  # Update dir if a path was provided as a trailing argument
  [[ -n "$1" ]] && dir="$1"

  # Clean Logic
  if [[ "$clean" == "true" ]]; then
    echo "Cleaning coverage files..."
    rm -rf cover/
    return 0
  fi

  # Optional dummy test generation
  if [[ "$generate_tests" == "true" ]]; then
    echo "Generating dummy test files for packages without tests..."
    local pkgs
    pkgs=$(go list -find -f '{{if (and (eq (len .XTestGoFiles) 0) (eq (len .TestGoFiles) 0))}}{{range .GoFiles}}{{$.Name}}:{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{end}}' "$dir" | grep -vE "$ignore" | xargs -I {} dirname {} | sort -u)

    for pkg in ${(f)pkgs}; do
      local name=$(echo "$pkg" | cut -f1 -d':')
      local p_path=$(echo "$pkg" | cut -f2 -d':')
      local base=$(basename "$p_path")
      echo "package ${name}_test" > "${p_path}/${base}_test.go"
    done
  fi

  # Run tests
  mkdir -p cover
  local timeout_cmd=()
  [[ -n "$timeout" ]] && timeout_cmd=(-timeout "$timeout")

  echo "Running tests for $dir"
  go test -cover -covermode count -coverprofile cover/gocover.tmp "${timeout_cmd[@]}" "$dir"

  # Process coverage
  if [[ -f cover/gocover.tmp ]]; then
    grep -vE "$ignore" cover/gocover.tmp > cover/gocover.out && rm cover/gocover.tmp
    go tool cover -func cover/gocover.out -o cover/gocover.func
    # Display the final total line
    tail -1 cover/gocover.func | tr -s '[:space:]'
  fi

  # Open report
  if [[ "$open_report" == "true" ]]; then
    go tool cover -html cover/gocover.out -o cover/gocover.html
    open cover/gocover.html
  fi
}
