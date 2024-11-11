#!/usr/bin/env bash

set -exo pipefail

# Init `dvc-test` dir and Git repo
mkdir dvc-test
cd dvc-test
git init

# Init DVC with default remote "remote" pointing at local dir `remote/`
dvc init
dvc config core.autostage true
remote="${remote:-/tmp/remote}"
dvc remote add remote "$remote"
dvc remote default remote
git commit -am 'dvc init'

# Add+Commit a DVC file, leave branch `branch` pointing at this Git commit
echo aaa > 1.txt
dvc add 1.txt
git commit -m 'echo aaa > 1.txt'
git branch branch

# Modify DVC file, commit
echo AAA > 1.txt
dvc add 1.txt
git commit -m 'echo AAA > 1.txt'

# ✅ 2 versions present in local cache
tree .dvc/cache/files/md5
# .dvc/cache/files/md5
# ├── 5c
# │   └── 9597f3c8245907ea71a89d9d39d08e
# └── 88
#     └── 80cd8c1fb402585779766f681b868b
#
# 3 directories, 2 files

# ❌ Push "all commits" (`-A`) to remote, but only latest version of 1.txt is pushed
dvc push -A
# Collecting
# Pushing
# 1 file pushed

# ❌ Confirming: current version of 1.txt was pushed to remote, but previous version was not:
tree "$remote/files/md5"
# remote/files/md5
# └── 88
#     └── 80cd8c1fb402585779766f681b868b
#
# 2 directories, 1 file

# ❌ Push "all branches" (`-a`) no-ops; previous version of 1.txt still missing
dvc push -a
# Collecting
# Pushing
# Everything is up to date.

# Confirming: branch `branch` points at previous commit
git --no-pager log --oneline --decorate
# c61818b (HEAD -> main) echo AAA > 1.txt
# 9efabca (branch) echo aaa > 1.txt
# 8298b00 dvc init

# Confirming: `branch:1.txt` was never pushed
git --no-pager show branch:1.txt.dvc
# outs:
# - md5: 5c9597f3c8245907ea71a89d9d39d08e
#   size: 4
#   hash: md5
#   path: 1.txt

missing_path="$remote/files/md5/5c/9597f3c8245907ea71a89d9d39d08e"
if [ -e "$missing_path" ]; then
    echo "✅ found $missing_path"
    exit 0
else
    echo "❌ missing $missing_path"
    exit 1
fi
