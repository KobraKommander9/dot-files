#!/usr/bin/env fish

function gocover
    argparse h/help c/clean 't/timeout=?' o/open -- $argv
    or return

    if set -ql _flag_help
        echo "gocover [-h|--help] [-c|--clean] [-t|--timeout] [-o|--open] [path]"
        echo "  -h, --help    show this help"
        echo "  -c, --clean   remove all generated test files"
        echo "  -t, --timeout set the timeout for the tests"
        echo "  -o, --open    open the coverage report in a browser"
        echo "  path          the path to the package to test; defaults to ./..."
        return 0
    end

    if set -ql _flag_clean
        rm cover/gocover.*
        return 0
    end

    if set -ql _flag_open
        set open true
    else
        set open false
    end

    if set -q "$argv"; or test -z "$argv[1]"
        set dir "./..."
    else
        set dir $argv[1]
    end

    set ignore "\(/*ctl/\|/testdata/\|/mock/\|/generate.go\|\.cp\.go\|\.pb\.go\|\.mg\.go\|\.mock\.go\)"
    set create (go list -find -f '{{if (and (eq (len .XTestGoFiles) 0) (eq (len .TestGoFiles) 0))}}{{range .GoFiles}}{{$.Name}}:{{$.Dir}}/{{.}}{{"\n"}}{{end}}{{end}}' $dir | grep -v $ignore | xargs dirname | sort -u)
    for package in $create
        set name (echo $package | cut -f1 -d':')
        set path (echo $package | cut -f2 -d':')
        set base (basename $path)
        echo package "$name"_test >"$path"/"$base"_test.go
    end

    mkdir -p cover

    if test -n "$_flag_timeout"
        go test -cover -covermode count -coverprofile cover/gocover.tmp -timeout $_flag_timeout $dir
    else
        go test -cover -covermode count -coverprofile cover/gocover.tmp $dir
    end

    cat cover/gocover.tmp | grep -v $ignore >cover/gocover.out && rm cover/gocover.tmp
    go tool cover -func cover/gocover.out -o cover/gocover.func
    cat cover/gocover.func | tail -1 | sed 's/[[:space:]][[:space:]]*/ /g'

    if $open
        go tool cover -html cover/gocover.out -o cover/gocover.html
        open cover/gocover.html
    end
end
