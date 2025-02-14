[36;1m# Created with https://github.com/gitcnd/git-meta.git v0.20250112 command:-[0m

/home/cnd/bin/git-meta.pl -newgit cursor_self_meta -master_location=~/Downloads/gitblobs/ -autopush -l .
[0m
[32;1mchmod g+x /home/cnd/Downloads/gitblobs[0m
[32;1mchmod g+s /home/cnd/Downloads/gitblobs[0m
[32;1msudo setfacl -d -m g::rwx /home/cnd/Downloads/gitblobs[0m

[37;1m# Create the master location[0m
[32;1mmkdir -p /home/cnd/Downloads/gitblobs/cursor_self_meta[0m
[32;1mchmod g+x /home/cnd/Downloads/gitblobs/cursor_self_meta[0m
[32;1mchmod g+s /home/cnd/Downloads/gitblobs/cursor_self_meta[0m
[32;1msetfacl -d -m g::rwx /home/cnd/Downloads/gitblobs/cursor_self_meta[0m
[32;1mcd /home/cnd/Downloads/gitblobs/cursor_self_meta;git init --bare;cd /home/cnd/Downloads/cursor[0m

[37;1m# Create one initial working folder[0m
[32;1mgit clone /home/cnd/Downloads/gitblobs/cursor_self_meta /home/cnd/Downloads/cursor/cursor_self_meta[0m
[32;1mchmod g+x /home/cnd/Downloads/cursor/cursor_self_meta[0m
[32;1mchmod g+s /home/cnd/Downloads/cursor/cursor_self_meta[0m
[32;1msetfacl -d -m g::rwx /home/cnd/Downloads/cursor/cursor_self_meta[0m
[32;1mcd /home/cnd/Downloads/cursor/cursor_self_meta;touch README.txt;git add README.txt;git commit -m Setup; git config push.default current; git push;cd /home/cnd/Downloads/cursor[0m

[37;1m# Setting up 'cursor_self_meta' to preserve dates[0m
[32;1mln -s /home/cnd/bin/git-meta.pl cursor_self_meta/.git/hooks/pre-commit[0m
[32;1mchmod ugo+x cursor_self_meta/.git/hooks/pre-commit[0m
[32;1mln -s /home/cnd/bin/git-meta.pl cursor_self_meta/.git/hooks/post-merge[0m
[32;1mchmod ugo+x cursor_self_meta/.git/hooks/post-merge[0m
[32;1mln -s /home/cnd/bin/git-meta.pl cursor_self_meta/.git/hooks/post-checkout[0m
[32;1mchmod ugo+x cursor_self_meta/.git/hooks/post-checkout[0m
[32;1mgit config --local core.fileMode false[0m
[36;1mIf doing "git clone" in other machines later, remember to copy the following files into your new location .git/hooks/ folder too:
	cursor_self_meta/.git/hooks/pre-commit
	cursor_self_meta/.git/hooks/post-merge
	cursor_self_meta/.git/hooks/post-checkout[0m
[32;1mln -s /home/cnd/bin/git-meta.pl cursor_self_meta/.git/hooks/post-commit[0m
[32;1mchmod ugo+x cursor_self_meta/.git/hooks/post-commit[0m
[33;1m# Created /.git/hooks/../.htaccess with "Require all denied"
[33;1m# Created empty /.git/hooks/../index.html
[33;1m# Created cursor_self_meta/.git/hooks/../.htaccess with "Require all denied"
[33;1m# Created empty cursor_self_meta/.git/hooks/../index.html

[37;1m[36;1m# Done! Try these next perhaps:[37;1m
pushd cursor_self_meta
echo hello > index.html
git add index.html
git commit -m Initial_Commit
git push
popd
[36;1m# And on some other machine:-[37;1m
git clone ssh://cdc.emsvr.com/home/cnd/Downloads/gitblobs/cursor_self_meta
cd cursor_self_meta
git-meta.pl -setup -l . -autopush 
[36;1m# (always remember to "git pull" before changing things when you're using multiple machines!)[0m[0m
