#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

PATH="$PATH:$DIR/bin"

SET_OUT_MODE=false;
if [ "$1" = "--set-out" ]; then
    SET_OUT_MODE=true;
    shift
elif [ "$2" = "--set-out" ]; then
    SET_OUT_MODE=true;
fi

cd $DIR

run_test() {
    res="$1"
    expected_res="$2"
    if [ "$res" != "$expected_res" ]; then
        echo " FAILED"
        echo "actual:"
        echo "--"
        echo "$res"
        echo "--"
        echo "expected:"
        echo "--"
        echo "$expected_res"
        echo "--"
        echo "diff:"
        diff  <(echo "$res" ) <(echo "$expected_res")
        exit 1;
    fi
}

shopt -s globstar
#find . -type d -name 'in' -print0
for test_set in ./${1}*/; do
    init_path="./$test_set/init"
    if [ ! -e "$init_path" ]; then
        continue;
    fi
 
    echo "Beginning test set: $test_set"
    SET_START=$(date +%s)

    "$init_path";

    echo "init took: $(($(date +%s)-SET_START)) seconds";

    for test_path in "$test_set"/${2}*/**/in; do
        in=$(<$test_path);
        if [ -e $test_path/../skip_test_if ]; then
            if $test_path/../skip_test_if; then
                continue;
            fi
        fi

        TEST_TYPE=none

        out_path_cli=$(echo -n $test_path | sed -e "s/cli\/in/cli\/out/g");
        out_path_shell=$(echo -n $test_path | sed -e "s/shell\/in/shell\/out/g");

        START=$(date +%s)

        if [ $out_path_cli = $test_path ]; then
            TEST_TYPE=shell;
            out_path=$out_path_shell;
        elif [ $out_path_shell = $test_path ]; then
            TEST_TYPE=cli;
            out_path=$out_path_cli;
        else
            TEST_TYPE=none
            continue;
        fi

        if [ -e $out_path ]; then
            echo -n "Running $TEST_TYPE test: $test_path: $out_path ..."
            if [ "$SET_OUT_MODE" = true ]; then
                if [ "$TEST_TYPE" = "cli" ]; then
                    echo "$in" | ncs_cli -u admin -C > "$out_path";
                    echo " set output to $out_path";
                elif [ "$TEST_TYPE" = "shell" ]; then
                    echo "$in" | /bin/bash -s > "$out_path";
                    echo " set output to $out_path";
                fi
            else
                if [ "$TEST_TYPE" = "cli" ]; then
                    out=$(<$out_path);
                    run_test "$(echo "$in" | ncs_cli -u admin -C)" "$out";
                elif [ "$TEST_TYPE" = "shell" ]; then
                    out=$(<$out_path);
                    run_test "$(echo "$in" | /bin/bash -s)" "$out";
                fi
            fi
            echo " PASS"
        else
            if [ "$TEST_TYPE" = "cli" ]; then
                echo -n "Running $TEST_TYPE test (no expected output): $test_path ..."
                echo "$in" | ncs_cli -u admin -C > /dev/null
            elif [ "$TEST_TYPE" = "shell" ]; then
                echo -n "Running $TEST_TYPE test (no expected output): $test_path ..."
                echo "$in" | /bin/bash -s > /dev/null
            fi
            echo " PASS"
        fi
        END=$(date +%s)
        echo " test took: $((END-START)) seconds";
    done
    SET_END=$(date +%s)
    echo "test set took: $((SET_END-SET_START)) seconds";
done
