#!/bin/bash

refname="for"
skip=0
# whitelist is for when it looks through the history of a hunk to see who should
# review. Everyone on the whitelist is allowed through if it exists
whitelist=$XDG_CONFIG_HOME/git/always-review.whitelist
# people on this list will never be added as reviewers if they're in the history
blacklist=$XDG_CONFIG_HOME/git/never-review.blacklist
# people on this list are always added as reviewers if it's present
alwayslist=$XDG_CONFIG_HOME/git/always-review.txt

while [ -n "$1" ]; do
    case "$1" in
    --help)
        help=true
        ;;
    --draft|-D)
        refname="drafts"
        ;;
    --without-reviewers|-O)
        skip=1
        ;;
    -*)
        echo "Error: Invalid option \"$1\"."
        exit 2
        ;;
    *)
        # Stop parsing options on the first non-option argument.
        break
        ;;
    esac

    shift
done

if [ -n "$help" -o $# -gt 2 ]; then
    echo "Rationale"
    echo "    Push commits of the current branch to Gerrit for review, optionally"
    echo "    determining reviewers excluding those in ~/gerrit-push-for.blacklist."
    echo
    echo "Usage"
    echo "    $(basename $0) [options] [target] [ref]"
    echo
    echo "Example"
    echo "    $(basename $0) development HEAD^"
    echo
    echo "Options"
    echo "    --help"
    echo "        Show this help."
    echo "    --draft, -D"
    echo "        Submit changes as a draft."
    echo "    --without-reviewers, -O"
    echo "        Do not attempt to determine reviewers."
    exit 1
fi

[ $# -ge 1 ] && target=$1 || target=master
[ $# -ge 2 ] && ref=$2 || ref=HEAD

remotes=$(git remote show)
if echo "$remotes" | grep -q ^gerrit$; then
    remote=gerrit
elif echo "$remotes" | grep -q ^origin$; then
    remote=origin
else
    remote=$(echo "$remotes" | head -1)
fi

revlist=$(git rev-list --first-parent $ref --not $remote/$target 2> /dev/null || git rev-list $ref 2> /dev/null)
if [ $? -eq 0 ]; then
    revcount=$(echo "$revlist" | wc -l)
    revcount=$(echo $revcount)
    if [ $revcount -eq 0 ]; then
        echo "Nothing to do, $ref is already merged into $remote/$target."
        exit 3
    fi
else
    revcount="an unknown number of"
fi

# Create changes from the command line with topic and reviewers optionally set, see:
# http://gerrit-documentation.googlecode.com/svn/Documentation/2.6/user-upload.html#push_create

# Specify a topic if we are on a branch different from the target.
topic=$(git rev-parse --abbrev-ref $ref)
topic=${topic#gerrit/}
topic=${topic#${USER-$USERNAME}/}

if [[ "$refname" == "drafts" ]]; then
    entity="draft(s)"
else
    entity="change(s)"
fi

if [[ "$topic" != "" && "$topic" != "HEAD" && "$topic" != "$target" ]]; then
    echo "Going to push $revcount \"$topic\" $entity for \"$remote/$target\"."
    options="%topic=$topic"
else
    echo "Going to push $revcount $entity for \"$remote/$target\"."
fi

if [ $skip -eq 0 ]; then
    # Determine email addresses of potential reviewers (except oneself).
    git help -a | grep -q " contacts "
    if [ $? -ne 0 ]; then
        read -p "git-contacts not found, do you want to download it? [(Y)es/(n)o] " -n 1 -r
        echo
        if [ "$REPLY" != "n" -a "$REPLY" != "N" ]; then
            exec_path=$(git --exec-path)
            if [ $? -eq 0 -a -n "$exec_path" ]; then
                curl -Lo "$exec_path/git-contacts" https://github.com/git/git/raw/master/contrib/contacts/git-contacts
                chmod +x $exec_path/git-contacts
            fi
        fi
        git help -a | grep -q " contacts "
    fi

    # Second try after potentially have downloaded git-contacts.
    if [ $? -eq 0 ]; then
        echo "Determining reviewers..."
        user=$(git config user.name)
        reviewers=$(git contacts $remote/$target..$ref 2> /dev/null | grep -iv "$user" | cut -d "<" -f 2 | cut -d ">" -f 1 | tr " " "\n" | sort -u)
        if [ -f $alwayslist ]; then
            dos2unix -k $alwayslist 2> /dev/null
            reviewers=$(echo "$reviewers $(echo $(cat $alwayslist))" | tr " " "\n" | sort -u) 
        fi
        if [ -f $whitelist ]; then
            dos2unix -k $whitelist 2> /dev/null
            reviewers=$(echo "$reviewers" | grep -f $whitelist)
        fi
        if [ -f $blacklist ]; then
            dos2unix -k $blacklist 2> /dev/null
            reviewers=$(echo "$reviewers" | grep -vf $blacklist)
        fi

        if [ "$reviewers" != "" ]; then
            # Determine the reviewer count, stripping (leading) whitespace.
            count=$(echo "$reviewers" | wc -l)
            count=$(echo $count)
            echo "Found $count possible reviewer(s):"

            for email in $reviewers; do
                echo "    $email"
                if [ -n "$r" ]; then
                    r="$r,"
                fi
                r="${r}r=$email"
            done
        else
            echo "No suitable reviewers found."
        fi
    else
        echo "git-contacts not available."
        skip=1
    fi
fi

if [ $skip -ne 0 ]; then
    echo "Skipping determining reviewers."
fi

if [ -n "$reviewers" ]; then
    choice="/with(o)ut reviewers"
fi
read -p "Do you want to push this review? [(Y)es$choice/(n)o] " -n 1 -r
echo

if [ "$REPLY" != "o" -a "$REPLY" != "O" ]; then
    if [ -n "$r" ]; then
        if [ -z "$options" ]; then
            options="%$r"
        else
            options="$options,$r"
        fi
    fi
fi

if [ "$REPLY" != "n" -a "$REPLY" != "N" ]; then
    git push $remote $ref:refs/$refname/$target$options
fi
