# [dvc#10617] repro

```bash
git clone https://github.com/ryan-williams/dvc-push-bug && cd dvc-push-bug
docker build -t dvc-push-bug .
docker run --rm dvc-push-bug
```

Example output:

```
+ mkdir dvc-test
+ cd dvc-test
+ git init
Initialized empty Git repository in /src/dvc-test/.git/
+ dvc init
Initialized DVC repository.

You can now commit the changes to git.

+---------------------------------------------------------------------+
|                                                                     |
|        DVC has enabled anonymous aggregate usage analytics.         |
|     Read the analytics documentation (and how to opt-out) here:     |
|             <https://dvc.org/doc/user-guide/analytics>              |
|                                                                     |
+---------------------------------------------------------------------+

What's next?
------------
- Check out the documentation: <https://dvc.org/doc>
- Get help and share ideas: <https://dvc.org/chat>
- Star us on GitHub: <https://github.com/iterative/dvc>
+ dvc config core.autostage true
+ remote=/tmp/remote
+ dvc remote add remote /tmp/remote
+ dvc remote default remote
+ git commit -m 'dvc init'
[main (root-commit) a975465] dvc init
 3 files changed, 6 insertions(+)
 create mode 100644 .dvc/.gitignore
 create mode 100644 .dvc/config
 create mode 100644 .dvcignore
+ echo aaa
+ dvc add 1.txt
+ git commit -m 'echo aaa > 1.txt'
[main 841e736] echo aaa > 1.txt
 2 files changed, 6 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 1.txt.dvc
+ git branch branch
+ echo AAA
+ dvc add 1.txt
+ git commit -m 'echo AAA > 1.txt'
[main 6e92bab] echo AAA > 1.txt
 1 file changed, 1 insertion(+), 1 deletion(-)
.dvc/cache/files/md5
├── 5c
│   └── 9597f3c8245907ea71a89d9d39d08e
└── 88
    └── 80cd8c1fb402585779766f681b868b

3 directories, 2 files
+ tree .dvc/cache/files/md5
+ dvc push -A
1 file pushed
+ tree /tmp/remote/files/md5
/tmp/remote/files/md5
└── 88
    └── 80cd8c1fb402585779766f681b868b

2 directories, 1 file
+ dvc push -a
Everything is up to date.
+ git --no-pager log --oneline --decorate
6e92bab (HEAD -> main) echo AAA > 1.txt
841e736 (branch) echo aaa > 1.txt
a975465 dvc init
+ git --no-pager show branch:1.txt.dvc
outs:
- md5: 5c9597f3c8245907ea71a89d9d39d08e
  size: 4
  hash: md5
  path: 1.txt
❌ missing /tmp/remote/files/md5/5c/9597f3c8245907ea71a89d9d39d08e
+ missing_path=/tmp/remote/files/md5/5c/9597f3c8245907ea71a89d9d39d08e
+ '[' -e /tmp/remote/files/md5/5c/9597f3c8245907ea71a89d9d39d08e ']'
+ echo '❌ missing /tmp/remote/files/md5/5c/9597f3c8245907ea71a89d9d39d08e'
```

[dvc#10617]: https://github.com/iterative/dvc/issues/10617
