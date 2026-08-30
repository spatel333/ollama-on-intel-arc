# Git commit struggles
This repo has faced blockades when pushing up to the remote branch. It includes the .tgz for __ollama-ipex-llm__, its unzipped directory, and the __Miniforge__ install script. All of which __exceeed the file size limits imposed by Git__.
Additionally, none are necessary for this project. Better to prune them out & append them to the .gitignore so as to maintain a clean workspace.

## ERROR MESSAGE
```
remote: error: Trace: 4bdb951bef70b52dfb53a5b3f0b13e38f5e10ff02fab993fce4214e25f8c969f
remote: error: See https://gh.io/lfs for more information.
remote: error: File Miniforge3-Linux-x86_64.sh is 118.44 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: File ollama-ipex-llm-2.3.0b20250725-ubuntu.tgz is 139.86 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: File ollama-ipex-llm-2.3.0b20250725-ubuntu/libmkl_sycl_blas.so.5 is 101.86 MB; this exceeds GitHub's file size limit of 100.00 MB
remote: error: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
To https://github.com/spatel333/ollama-on-intel-arc.git
 ! [remote rejected] main -> main (pre-receive hook declined)
error: failed to push some refs to 'https://github.com/spatel333/ollama-on-intel-arc.git'
```

## Work done
Added a .gitignore file
```
*.tgz
ollama-ipex-llm-2.3.0b20250725-ubuntu/
logs/
Miniforge3-Linux-x86_64.sh
```

Removed files from git cache
```
git rm -r --cached ollama-ipex-llm-2.3.0b20250725-ubuntu/
git rm --cached ollama-ipex-llm-2.3.0b20250725-ubuntu.tgz
git rm --cached Miniforge3-Linux-x86_64.sh
```

Checked using `git diff --stat --cached origin/main'
File was not a part of the cache

> ERROR STILL PERSISTS

## Claude's deduction
```
The core problem: git rm --cached only tells Git to stop tracking the file going forward — it doesn't touch the blob sitting inside the earlier commits. When you git push, Git has to transfer every commit (and every object those commits reference) that the remote doesn't already have. Since the tarball was added in an earlier commit, that oversized blob is still baked into your commit history and gets sent along with everything else, tripping GitHub's per-file limit (hard block at 100MB, warning above 50MB).

That's also why git diff --stat --cached origin/main looked clean — it only compares your current staged tree against the remote tip, not the blobs embedded in intermediate commits along the way.

So the fix isn't "remove from tracking," it's "remove from history."
```

